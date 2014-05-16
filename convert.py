#!/usr/bin/env python

import plistlib
import os
import os.path

def generate_image_filename(prefix, used_filenames):
  index = 1
  filename = '%s.png' % prefix

  while filename in used_filenames:
    filename = '%s-%d.png' % (prefix, index)
    index += 1

  used_filenames.add(filename)

  return filename

def write_snapshot(name, suffix, data, out_dirname, used_filenames, indent):
  if not data:
    return

  filename = generate_image_filename('%s-%s' % (name, suffix), used_filenames)
  path = os.path.join(out_dirname, filename)

  with open(path, 'w') as image_file:
    image_file.write(data.data)

  print '%s* %s: %s' % (' ' * indent, suffix, path)

def convert_layer(layer, out_dirname='', indent=0, used_filenames=set()):
  name = layer.get('view', layer['layer'])
  print '%s%s: %s' % (' ' * indent, name, layer['frame'])

  for suffix in ['contents', 'snapshot']:
    write_snapshot(name, suffix, layer.get(suffix, None), out_dirname, used_filenames, indent)

  for sublayer in layer.get('children', []):
    convert_layer(sublayer, out_dirname, indent + 2, used_filenames)

def convert_file(dump_filename, out_dirname=None):
  with open(dump_filename, 'r') as dump_file:
    dump = plistlib.readPlist(dump_filename)

    for window in dump:
      convert_layer(window)

if __name__ == '__main__':
  convert_file('/Users/frd/Library/Application Support/iPhone Simulator/7.1/Applications/C6518D3C-E026-4480-820E-1315E23A06C0/tmp/dump.plist')
