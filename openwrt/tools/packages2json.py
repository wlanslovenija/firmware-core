#!/usr/bin/env python
import sys
import json

packages = {}
package = {}
last_key = None
for line in sys.stdin:
    if (not line or line == '\n') and package:
        packages[package['name']] = package
        package = {}
        last_key = None
        continue

    if line[0] != ' ':
        key, value = line.split(': ')
        keys = {
            'Package': 'name',
            'Version': 'version',
            'Depends': ('dependencies', lambda x: x.split(', ')),
            'Source': 'source',
            'Installed-Size': ('size_installed', int),
            'Size': ('size', int),
            'MD5Sum': 'checksum_md5',
            'SHA256sum': 'checksum_sha256',
            'Description': 'description',
        }

        last_key = None
        if key not in keys:
            continue

        try:
            last_key, converter = keys[key]
        except ValueError:
            last_key = keys[key]
            converter = str

        package[last_key] = converter(value.strip())
    elif last_key:
        package[last_key] += '\n' + line[1:].strip()

sys.stdout.write(json.dumps(packages))
