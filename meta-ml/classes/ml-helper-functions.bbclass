inherit python3-dir

def get_major_python_version(d):
    version = d.getVar('PYTHON_BASEVERSION')
    if not version:
        return
    return version.split('.')[0]

def get_minor_python_version(d):
    version = d.getVar('PYTHON_BASEVERSION')
    if not version:
        return
    return version.split('.')[1] if len(version.split('.')) > 1 else ''
