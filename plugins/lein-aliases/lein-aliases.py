#!/usr/bin/env python
from __future__ import print_function
import re

def readFile(filename):
  try:
    file = open(filename, 'r')
    content = file.read()
    file.close()
    return content
  except IOError as e:
    print('', end='')

def parse_key_and_values(raw):
  no_double_quotes = raw.replace('"', '')
  no_last_bracket = re.sub(r']\s*$','', no_double_quotes)
  key_value_strings = no_last_bracket.split(']')
  return map(key_value_string_to_pair, key_value_strings)

def key_value_string_to_pair(key_value_str):
  key_and_value = key_value_str.split('[')
  return key_and_value[0].strip() + ":ALIAS: " + key_and_value[1]

def read_aliases(filename):
  keys_and_commands = re.search('(?<=:aliases {").*?(?=})', readFile(filename).replace('\n', ''))

  if keys_and_commands is None:
    return []
  else:
    keys_and_commands_raw = keys_and_commands.group(0)
    return parse_key_and_values(keys_and_commands_raw)

aliases_from_project = read_aliases('project.clj')

out = ';'.join(aliases_from_project)
print(out, end='')
