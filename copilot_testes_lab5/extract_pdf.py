import pypdf
import sys

pdf_path = r"c:\Users\ferna\Downloads\Laboratorio 5.pdf"
try:
    reader = pypdf.PdfReader(pdf_path)
    text = ""
    for page_num, page in enumerate(reader.pages):
        text += f"\n--- PAGE {page_num + 1} ---\n"
        text += page.extract_text()
    print(text)
except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(1)
