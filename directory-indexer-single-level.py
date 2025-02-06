import os
from datetime import datetime

def create_index_html(root_dir):
    """
    Creates an index.html file listing only immediate subdirectories.
    """
    html_template = """<!DOCTYPE html>
<html>
<head>
    <title>Directory Index</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .directory { font-weight: bold; color: #2c3e50; }
        table { border-collapse: collapse; width: 100%; }
        th, td { padding: 8px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #f5f5f5; }
        tr:hover { background-color: #f5f5f5; }
    </style>
</head>
<body>
    <h1>Directory Index</h1>
    <table>
        <tr>
            <th>Directory</th>
            <th>Last Modified</th>
            <th>Items</th>
        </tr>
"""

    # Get all immediate subdirectories
    subdirs = [d for d in os.listdir(root_dir) if os.path.isdir(os.path.join(root_dir, d))]
    subdirs.sort()

    # Add each directory to the index
    for directory in subdirs:
        path = os.path.join(root_dir, directory)
        modified_time = datetime.fromtimestamp(os.path.getmtime(path))
        
        # Count items in the directory
        try:
            item_count = len(os.listdir(path))
        except PermissionError:
            item_count = "N/A"

        html_template += f"""
        <tr>
            <td><a href="{directory}/" class="directory">{directory}/</a></td>
            <td>{modified_time.strftime('%Y-%m-%d %H:%M:%S')}</td>
            <td>{item_count}</td>
        </tr>"""

    html_template += """
    </table>
</body>
</html>
"""

    # Write the index.html file
    with open(os.path.join(root_dir, 'index.html'), 'w', encoding='utf-8') as f:
        f.write(html_template)

if __name__ == "__main__":
    current_dir = os.getcwd()
    create_index_html(current_dir)
    print(f"Created index.html in {current_dir}")
