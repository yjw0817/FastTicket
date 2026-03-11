#!/usr/bin/env python3
"""Google Sheets CLI — OAuth-based read/write/format operations.

Dependencies (install once):
    pip install google-auth google-auth-oauthlib google-api-python-client

Usage:
    python gsheet.py auth   --credentials <path>          # one-time OAuth setup
    python gsheet.py info   --id <spreadsheet_id>         # list sheets & metadata
    python gsheet.py read   --id <id> [--range 'Sheet1!A1:D10']
    python gsheet.py write  --id <id> --range 'Sheet1!B5' --values '[["Completed"]]'
    python gsheet.py append --id <id> --sheet Sheet1 --values '[["row1col1","row1col2"]]'
    python gsheet.py create --title 'My New Sheet'
    python gsheet.py add-sheet --id <id> --title 'NewTab'
    python gsheet.py format --id <id> --range 'Sheet1!A1:D1' --bold true --bg '#4285F4'
    python gsheet.py clear  --id <id> --range 'Sheet1!A1:Z100'
    python gsheet.py copy-row --id <id> --source-row 3 --target-row 7 --sheet Sheet1
    python gsheet.py search --id <id> --query 'keyword' [--exact]
    python gsheet.py sort   --id <id> --range 'Sheet1!A1:F100' --column B --order asc
    python gsheet.py resize --id <id> --type col --index B --size 200
    python gsheet.py cond-format --id <id> --range 'Sheet1!C2:C100' --condition number_gt --values 90 --bg '#00FF00'
"""

import argparse
import json
import os
import re
import sys
from pathlib import Path

SCOPES = ["https://www.googleapis.com/auth/spreadsheets"]
TOKEN_PATH = Path.home() / ".gsheet_token.json"
CREDS_PATH = Path.home() / ".gsheet_credentials.json"


# ── helpers ──────────────────────────────────────────────────────────────
def _err(msg: str):
    print(json.dumps({"error": msg}))
    sys.exit(1)


def _ok(data):
    print(json.dumps(data, indent=2, default=str))


def extract_spreadsheet_id(raw: str) -> str:
    """Accept a full Google Sheets URL or a plain spreadsheet ID."""
    m = re.search(r"/spreadsheets/d/([a-zA-Z0-9_-]+)", raw)
    return m.group(1) if m else raw


def get_service():
    """Return an authorized Sheets API service object."""
    try:
        from google.auth.transport.requests import Request
        from google.oauth2.credentials import Credentials
    except ImportError:
        _err("Missing deps. Run: pip install google-auth google-auth-oauthlib google-api-python-client")

    creds = None
    if TOKEN_PATH.exists():
        creds = Credentials.from_authorized_user_file(str(TOKEN_PATH), SCOPES)

    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
            TOKEN_PATH.write_text(creds.to_json())
        else:
            _err(
                "Not authenticated. Run: python gsheet.py auth --credentials <path/to/credentials.json>"
            )

    from googleapiclient.discovery import build
    return build("sheets", "v4", credentials=creds)


# ── commands ─────────────────────────────────────────────────────────────
def cmd_auth(args):
    """One-time OAuth consent flow. Opens browser for Google sign-in."""
    try:
        from google_auth_oauthlib.flow import InstalledAppFlow
    except ImportError:
        _err("Missing deps. Run: pip install google-auth google-auth-oauthlib google-api-python-client")

    creds_file = args.credentials
    if not os.path.isfile(creds_file):
        _err(f"Credentials file not found: {creds_file}")

    # Optionally copy to home for future reference
    import shutil
    shutil.copy2(creds_file, str(CREDS_PATH))

    flow = InstalledAppFlow.from_client_secrets_file(creds_file, SCOPES)
    creds = flow.run_local_server(port=0)
    TOKEN_PATH.write_text(creds.to_json())
    _ok({"status": "authenticated", "token_saved": str(TOKEN_PATH)})


def cmd_info(args):
    """Get spreadsheet metadata: title, sheets list, properties."""
    svc = get_service()
    sid = extract_spreadsheet_id(args.id)
    meta = svc.spreadsheets().get(spreadsheetId=sid).execute()
    sheets = [
        {
            "title": s["properties"]["title"],
            "sheetId": s["properties"]["sheetId"],
            "rows": s["properties"]["gridProperties"]["rowCount"],
            "cols": s["properties"]["gridProperties"]["columnCount"],
        }
        for s in meta.get("sheets", [])
    ]
    _ok({"title": meta["properties"]["title"], "spreadsheetId": sid, "sheets": sheets})


def cmd_read(args):
    """Read cell values from a range (default: first sheet, all data)."""
    svc = get_service()
    sid = extract_spreadsheet_id(args.id)
    rng = args.range or ""

    if rng:
        result = svc.spreadsheets().values().get(spreadsheetId=sid, range=rng).execute()
    else:
        # read entire first sheet
        meta = svc.spreadsheets().get(spreadsheetId=sid).execute()
        first_sheet = meta["sheets"][0]["properties"]["title"]
        result = svc.spreadsheets().values().get(spreadsheetId=sid, range=first_sheet).execute()

    rows = result.get("values", [])
    _ok({"range": result.get("range"), "rows": len(rows), "values": rows})


def cmd_write(args):
    """Write values to a specific range (overwrites existing data)."""
    svc = get_service()
    sid = extract_spreadsheet_id(args.id)
    values = json.loads(args.values)

    # Convert \n string to actual newline for cell line breaks
    values = [[cell.replace("\\n", "\n") if isinstance(cell, str) else cell for cell in row] for row in values]

    body = {"values": values}
    result = (
        svc.spreadsheets()
        .values()
        .update(
            spreadsheetId=sid,
            range=args.range,
            valueInputOption="USER_ENTERED",
            body=body,
        )
        .execute()
    )
    _ok({
        "updatedRange": result.get("updatedRange"),
        "updatedRows": result.get("updatedRows"),
        "updatedCells": result.get("updatedCells"),
    })


def cmd_append(args):
    """Append rows after the last row with data."""
    svc = get_service()
    sid = extract_spreadsheet_id(args.id)
    values = json.loads(args.values)
    sheet = args.sheet or "Sheet1"

    body = {"values": values}
    result = (
        svc.spreadsheets()
        .values()
        .append(
            spreadsheetId=sid,
            range=sheet,
            valueInputOption="USER_ENTERED",
            insertDataOption="INSERT_ROWS",
            body=body,
        )
        .execute()
    )
    updates = result.get("updates", {})
    _ok({
        "updatedRange": updates.get("updatedRange"),
        "updatedRows": updates.get("updatedRows"),
        "updatedCells": updates.get("updatedCells"),
    })


def cmd_create(args):
    """Create a brand-new spreadsheet."""
    svc = get_service()
    body = {"properties": {"title": args.title}}
    result = svc.spreadsheets().create(body=body, fields="spreadsheetId,spreadsheetUrl").execute()
    _ok({
        "spreadsheetId": result["spreadsheetId"],
        "url": result["spreadsheetUrl"],
    })


def cmd_add_sheet(args):
    """Add a new sheet/tab to an existing spreadsheet."""
    svc = get_service()
    sid = extract_spreadsheet_id(args.id)
    body = {
        "requests": [
            {"addSheet": {"properties": {"title": args.title}}}
        ]
    }
    result = svc.spreadsheets().batchUpdate(spreadsheetId=sid, body=body).execute()
    props = result["replies"][0]["addSheet"]["properties"]
    _ok({"sheetId": props["sheetId"], "title": props["title"]})


def cmd_format(args):
    """Apply formatting (bold, italic, bg color, text color, font size) to a range."""
    svc = get_service()
    sid = extract_spreadsheet_id(args.id)

    # Parse range into sheetId + grid range
    range_str = args.range
    meta = svc.spreadsheets().get(spreadsheetId=sid).execute()

    # Determine sheet name and cell range
    if "!" in range_str:
        sheet_name, cell_range = range_str.split("!", 1)
    else:
        sheet_name = meta["sheets"][0]["properties"]["title"]
        cell_range = range_str

    # Find sheetId
    sheet_id = None
    for s in meta["sheets"]:
        if s["properties"]["title"] == sheet_name:
            sheet_id = s["properties"]["sheetId"]
            break
    if sheet_id is None:
        _err(f"Sheet '{sheet_name}' not found")

    # Convert A1 notation to grid range
    grid_range = _a1_to_grid(cell_range, sheet_id)

    # Build cell format
    cell_format = {}
    fields = []

    if args.bold is not None:
        cell_format.setdefault("textFormat", {})["bold"] = args.bold.lower() == "true"
        fields.append("userEnteredFormat.textFormat.bold")

    if args.italic is not None:
        cell_format.setdefault("textFormat", {})["italic"] = args.italic.lower() == "true"
        fields.append("userEnteredFormat.textFormat.italic")

    if args.font_size is not None:
        cell_format.setdefault("textFormat", {})["fontSize"] = int(args.font_size)
        fields.append("userEnteredFormat.textFormat.fontSize")

    if args.bg is not None:
        cell_format["backgroundColor"] = _hex_to_color(args.bg)
        fields.append("userEnteredFormat.backgroundColor")

    if args.fg is not None:
        cell_format.setdefault("textFormat", {})["foregroundColor"] = _hex_to_color(args.fg)
        fields.append("userEnteredFormat.textFormat.foregroundColor")

    if not fields:
        _err("No formatting options provided. Use --bold, --italic, --bg, --fg, --font-size")

    body = {
        "requests": [
            {
                "repeatCell": {
                    "range": grid_range,
                    "cell": {"userEnteredFormat": cell_format},
                    "fields": ",".join(fields),
                }
            }
        ]
    }
    svc.spreadsheets().batchUpdate(spreadsheetId=sid, body=body).execute()
    _ok({"formatted": range_str, "applied": fields})


def cmd_copy_row(args):
    """Copy a row and insert it at a target position."""
    svc = get_service()
    sid = extract_spreadsheet_id(args.id)
    sheet_name = args.sheet or "Sheet1"
    src_row = int(args.source_row)
    tgt_row = int(args.target_row)

    # Get sheetId
    meta = svc.spreadsheets().get(spreadsheetId=sid).execute()
    sheet_id = None
    for s in meta["sheets"]:
        if s["properties"]["title"] == sheet_name:
            sheet_id = s["properties"]["sheetId"]
            break
    if sheet_id is None:
        _err(f"Sheet '{sheet_name}' not found")

    # Step 1: Read source row data
    read_range = f"{sheet_name}!{src_row}:{src_row}"
    result = svc.spreadsheets().values().get(spreadsheetId=sid, range=read_range).execute()
    row_data = result.get("values", [[]])[0]

    if not row_data:
        _err(f"Row {src_row} is empty")

    # Step 2: Insert empty row at target position
    insert_idx = tgt_row - 1  # 0-based
    body = {
        "requests": [
            {
                "insertDimension": {
                    "range": {
                        "sheetId": sheet_id,
                        "dimension": "ROWS",
                        "startIndex": insert_idx,
                        "endIndex": insert_idx + 1,
                    },
                    "inheritFromBefore": insert_idx > 0,
                }
            }
        ]
    }
    svc.spreadsheets().batchUpdate(spreadsheetId=sid, body=body).execute()

    # Step 3: Write copied data to the new row
    write_range = f"{sheet_name}!A{tgt_row}"
    svc.spreadsheets().values().update(
        spreadsheetId=sid,
        range=write_range,
        valueInputOption="USER_ENTERED",
        body={"values": [row_data]},
    ).execute()

    _ok({
        "copiedFrom": f"row {src_row}",
        "insertedAt": f"row {tgt_row}",
        "columns": len(row_data),
        "data": row_data,
    })


def cmd_search(args):
    """Search for cells containing a specific value."""
    svc = get_service()
    sid = extract_spreadsheet_id(args.id)
    sheet_name = args.sheet or ""
    query = args.query
    exact = getattr(args, "exact", False)

    # Determine range to search
    if sheet_name:
        search_range = sheet_name
    else:
        meta = svc.spreadsheets().get(spreadsheetId=sid).execute()
        sheet_name = meta["sheets"][0]["properties"]["title"]
        search_range = sheet_name

    result = svc.spreadsheets().values().get(spreadsheetId=sid, range=search_range).execute()
    rows = result.get("values", [])

    matches = []
    query_lower = query.lower()
    for r_idx, row in enumerate(rows):
        for c_idx, cell in enumerate(row):
            cell_str = str(cell)
            if exact:
                found = cell_str == query
            else:
                found = query_lower in cell_str.lower()
            if found:
                col_letter = _index_to_col(c_idx)
                matches.append({
                    "cell": f"{sheet_name}!{col_letter}{r_idx + 1}",
                    "row": r_idx + 1,
                    "col": col_letter,
                    "value": cell_str,
                })

    _ok({"query": query, "exact": exact, "matches": len(matches), "results": matches})


def cmd_sort(args):
    """Sort a range by a specific column."""
    svc = get_service()
    sid = extract_spreadsheet_id(args.id)
    range_str = args.range
    sort_col = args.column.upper()
    order = args.order.upper() if args.order else "ASCENDING"
    if order in ("ASC", "A"):
        order = "ASCENDING"
    elif order in ("DESC", "D"):
        order = "DESCENDING"

    meta = svc.spreadsheets().get(spreadsheetId=sid).execute()

    if "!" in range_str:
        sheet_name, cell_range = range_str.split("!", 1)
    else:
        sheet_name = meta["sheets"][0]["properties"]["title"]
        cell_range = range_str

    sheet_id = None
    for s in meta["sheets"]:
        if s["properties"]["title"] == sheet_name:
            sheet_id = s["properties"]["sheetId"]
            break
    if sheet_id is None:
        _err(f"Sheet '{sheet_name}' not found")

    grid_range = _a1_to_grid(cell_range, sheet_id)
    sort_col_idx = _col_to_index(sort_col)

    body = {
        "requests": [
            {
                "sortRange": {
                    "range": grid_range,
                    "sortSpecs": [
                        {
                            "dimensionIndex": sort_col_idx,
                            "sortOrder": order,
                        }
                    ],
                }
            }
        ]
    }
    svc.spreadsheets().batchUpdate(spreadsheetId=sid, body=body).execute()
    _ok({"sorted": range_str, "byColumn": sort_col, "order": order})


def cmd_resize(args):
    """Resize row height or column width."""
    svc = get_service()
    sid = extract_spreadsheet_id(args.id)
    sheet_name = args.sheet or "Sheet1"
    dim_type = args.type.upper()  # ROW or COL
    size = int(args.size)

    meta = svc.spreadsheets().get(spreadsheetId=sid).execute()
    sheet_id = None
    for s in meta["sheets"]:
        if s["properties"]["title"] == sheet_name:
            sheet_id = s["properties"]["sheetId"]
            break
    if sheet_id is None:
        _err(f"Sheet '{sheet_name}' not found")

    # Parse index: number for rows, letter for columns
    idx_raw = args.index
    if dim_type in ("COL", "COLUMN", "COLUMNS"):
        dimension = "COLUMNS"
        if idx_raw.isalpha():
            start_idx = _col_to_index(idx_raw)
        else:
            start_idx = int(idx_raw) - 1
    else:
        dimension = "ROWS"
        start_idx = int(idx_raw) - 1

    body = {
        "requests": [
            {
                "updateDimensionProperties": {
                    "range": {
                        "sheetId": sheet_id,
                        "dimension": dimension,
                        "startIndex": start_idx,
                        "endIndex": start_idx + 1,
                    },
                    "properties": {"pixelSize": size},
                    "fields": "pixelSize",
                }
            }
        ]
    }
    svc.spreadsheets().batchUpdate(spreadsheetId=sid, body=body).execute()
    _ok({"resized": dimension, "index": idx_raw, "pixelSize": size})


def cmd_cond_format(args):
    """Add conditional formatting rule to a range.

    Supported conditions:
      text_contains, text_not_contains, text_eq,
      number_gt, number_gte, number_lt, number_lte, number_eq, number_between,
      not_blank, blank, custom_formula
    """
    svc = get_service()
    sid = extract_spreadsheet_id(args.id)
    range_str = args.range
    condition = args.condition.lower()
    values = args.values or []

    meta = svc.spreadsheets().get(spreadsheetId=sid).execute()

    if "!" in range_str:
        sheet_name, cell_range = range_str.split("!", 1)
    else:
        sheet_name = meta["sheets"][0]["properties"]["title"]
        cell_range = range_str

    sheet_id = None
    for s in meta["sheets"]:
        if s["properties"]["title"] == sheet_name:
            sheet_id = s["properties"]["sheetId"]
            break
    if sheet_id is None:
        _err(f"Sheet '{sheet_name}' not found")

    grid_range = _a1_to_grid(cell_range, sheet_id)

    # Map user-friendly condition names to API types
    condition_map = {
        "text_contains":     "TEXT_CONTAINS",
        "text_not_contains": "TEXT_NOT_CONTAINS",
        "text_eq":           "TEXT_EQ",
        "number_gt":         "NUMBER_GREATER",
        "number_gte":        "NUMBER_GREATER_THAN_EQ",
        "number_lt":         "NUMBER_LESS",
        "number_lte":        "NUMBER_LESS_THAN_EQ",
        "number_eq":         "NUMBER_EQ",
        "number_between":    "NUMBER_BETWEEN",
        "not_blank":         "NOT_BLANK",
        "blank":             "BLANK",
        "custom_formula":    "CUSTOM_FORMULA",
    }

    api_type = condition_map.get(condition)
    if not api_type:
        _err(f"Unknown condition '{condition}'. Supported: {', '.join(condition_map.keys())}")

    # Build condition values
    cond_values = [{"userEnteredValue": v} for v in values]

    # Build format
    fmt = {}
    if args.bg:
        fmt["backgroundColor"] = _hex_to_color(args.bg)
    if args.fg:
        fmt.setdefault("textFormat", {})["foregroundColor"] = _hex_to_color(args.fg)
    if args.bold:
        fmt.setdefault("textFormat", {})["bold"] = args.bold.lower() == "true"

    if not fmt:
        _err("Provide at least one format: --bg, --fg, or --bold")

    rule = {
        "addConditionalFormatRule": {
            "rule": {
                "ranges": [grid_range],
                "booleanRule": {
                    "condition": {
                        "type": api_type,
                        "values": cond_values,
                    },
                    "format": fmt,
                },
            },
            "index": 0,
        }
    }

    body = {"requests": [rule]}
    svc.spreadsheets().batchUpdate(spreadsheetId=sid, body=body).execute()
    _ok({"conditionApplied": condition, "range": range_str, "format": fmt})


def cmd_clear(args):
    """Clear all values from a range."""
    svc = get_service()
    sid = extract_spreadsheet_id(args.id)
    svc.spreadsheets().values().clear(spreadsheetId=sid, range=args.range, body={}).execute()
    _ok({"cleared": args.range})


# ── format helpers ───────────────────────────────────────────────────────
def _hex_to_color(hex_str: str) -> dict:
    """Convert '#RRGGBB' to Google Sheets color dict (0-1 floats)."""
    h = hex_str.lstrip("#")
    r, g, b = int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16)
    return {"red": r / 255, "green": g / 255, "blue": b / 255}


def _col_to_index(col: str) -> int:
    """Convert column letter(s) to 0-based index. A=0, B=1, ..., Z=25, AA=26."""
    result = 0
    for ch in col.upper():
        result = result * 26 + (ord(ch) - ord("A") + 1)
    return result - 1


def _index_to_col(idx: int) -> str:
    """Convert 0-based index to column letter(s). 0=A, 1=B, ..., 25=Z, 26=AA."""
    result = ""
    idx += 1
    while idx > 0:
        idx, rem = divmod(idx - 1, 26)
        result = chr(65 + rem) + result
    return result


def _a1_to_grid(cell_range: str, sheet_id: int) -> dict:
    """Convert 'A1:D10' to a GridRange dict."""
    pattern = r"([A-Za-z]+)(\d+)(?::([A-Za-z]+)(\d+))?"
    m = re.match(pattern, cell_range)
    if not m:
        _err(f"Invalid range format: {cell_range}")

    start_col, start_row = m.group(1), int(m.group(2))
    grid = {
        "sheetId": sheet_id,
        "startRowIndex": start_row - 1,
        "startColumnIndex": _col_to_index(m.group(1)),
    }
    if m.group(3) and m.group(4):
        grid["endRowIndex"] = int(m.group(4))
        grid["endColumnIndex"] = _col_to_index(m.group(3)) + 1
    else:
        grid["endRowIndex"] = start_row
        grid["endColumnIndex"] = _col_to_index(m.group(1)) + 1
    return grid


# ── CLI ──────────────────────────────────────────────────────────────────
def main():
    parser = argparse.ArgumentParser(description="Google Sheets CLI")
    sub = parser.add_subparsers(dest="command")

    # auth
    p = sub.add_parser("auth", help="One-time OAuth setup")
    p.add_argument("--credentials", required=True, help="Path to OAuth credentials.json")

    # info
    p = sub.add_parser("info", help="Spreadsheet metadata")
    p.add_argument("--id", required=True, help="Spreadsheet ID or URL")

    # read
    p = sub.add_parser("read", help="Read values")
    p.add_argument("--id", required=True)
    p.add_argument("--range", help="e.g. 'Sheet1!A1:D10'")

    # write
    p = sub.add_parser("write", help="Write/update values")
    p.add_argument("--id", required=True)
    p.add_argument("--range", required=True, help="e.g. 'Sheet1!B5'")
    p.add_argument("--values", required=True, help='JSON 2D array, e.g. \'[["Completed"]]\'')

    # append
    p = sub.add_parser("append", help="Append rows")
    p.add_argument("--id", required=True)
    p.add_argument("--sheet", default="Sheet1")
    p.add_argument("--values", required=True, help='JSON 2D array')

    # create
    p = sub.add_parser("create", help="Create new spreadsheet")
    p.add_argument("--title", required=True)

    # add-sheet
    p = sub.add_parser("add-sheet", help="Add tab to spreadsheet")
    p.add_argument("--id", required=True)
    p.add_argument("--title", required=True)

    # format
    p = sub.add_parser("format", help="Format cells")
    p.add_argument("--id", required=True)
    p.add_argument("--range", required=True)
    p.add_argument("--bold", help="true/false")
    p.add_argument("--italic", help="true/false")
    p.add_argument("--bg", help="Background color hex e.g. '#4285F4'")
    p.add_argument("--fg", help="Text color hex e.g. '#FFFFFF'")
    p.add_argument("--font-size", help="Font size in pt")

    # clear
    p = sub.add_parser("clear", help="Clear a range")
    p.add_argument("--id", required=True)
    p.add_argument("--range", required=True)

    # copy-row
    p = sub.add_parser("copy-row", help="Copy a row and insert at target position")
    p.add_argument("--id", required=True)
    p.add_argument("--source-row", required=True, help="Row number to copy (1-based)")
    p.add_argument("--target-row", required=True, help="Row number to insert at (1-based)")
    p.add_argument("--sheet", default="Sheet1", help="Sheet name")

    # search
    p = sub.add_parser("search", help="Find cells containing a value")
    p.add_argument("--id", required=True)
    p.add_argument("--query", required=True, help="Text to search for")
    p.add_argument("--sheet", default="", help="Sheet name (default: first sheet)")
    p.add_argument("--exact", action="store_true", help="Exact match only")

    # sort
    p = sub.add_parser("sort", help="Sort a range by column")
    p.add_argument("--id", required=True)
    p.add_argument("--range", required=True, help="e.g. 'Sheet1!A1:F100'")
    p.add_argument("--column", required=True, help="Column letter to sort by, e.g. 'B'")
    p.add_argument("--order", default="asc", help="asc or desc")

    # resize
    p = sub.add_parser("resize", help="Resize row height or column width")
    p.add_argument("--id", required=True)
    p.add_argument("--sheet", default="Sheet1")
    p.add_argument("--type", required=True, help="'row' or 'col'")
    p.add_argument("--index", required=True, help="Row number or column letter")
    p.add_argument("--size", required=True, help="Size in pixels")

    # cond-format
    p = sub.add_parser("cond-format", help="Add conditional formatting rule")
    p.add_argument("--id", required=True)
    p.add_argument("--range", required=True)
    p.add_argument("--condition", required=True,
                   help="text_contains, text_eq, number_gt, number_lt, number_eq, "
                        "number_between, blank, not_blank, custom_formula")
    p.add_argument("--values", nargs="*", default=[], help="Condition values (e.g. '100' or '10' '90' for between)")
    p.add_argument("--bg", help="Background color hex e.g. '#FF0000'")
    p.add_argument("--fg", help="Text color hex")
    p.add_argument("--bold", help="true/false")

    args = parser.parse_args()
    if not args.command:
        parser.print_help()
        sys.exit(1)

    commands = {
        "auth": cmd_auth,
        "info": cmd_info,
        "read": cmd_read,
        "write": cmd_write,
        "append": cmd_append,
        "create": cmd_create,
        "add-sheet": cmd_add_sheet,
        "format": cmd_format,
        "clear": cmd_clear,
        "copy-row": cmd_copy_row,
        "search": cmd_search,
        "sort": cmd_sort,
        "resize": cmd_resize,
        "cond-format": cmd_cond_format,
    }
    commands[args.command](args)


if __name__ == "__main__":
    main()
