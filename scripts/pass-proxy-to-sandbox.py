#!/usr/bin/env python3

import re
from os import environ as env

maven_template = '''\
  <proxies>
   <proxy>
      <id>%s</id>
      <active>true</active>
      <protocol>%s</protocol>
      <host>%s</host>
      <port>%s</port>%s
      <nonProxyHosts>%s</nonProxyHosts>
    </proxy>
  </proxies>
'''

proxy_auth='''
      <username>%s</username>
      <password>%s</password>'''

def get_proxy(protocol):
    ret = {}
    proxy = env.get('%s_proxy' % protocol.lower(), None)
    proxy = proxy or env.get('%s_PROXY' % protocol.upper(), None)
    ret['url'] = proxy

    if proxy is None:
        return None

    m = re.search(r'^https?://(([^@:]*):([^@:]*)@)?([^:]+):(\d*)', proxy)

    if m.group(2) is not None and m.group(3) is not None:
        ret['username'] = m.group(2)
        ret['password'] = m.group(3)

    ret['host'] = m.group(4)
    ret['port'] = m.group(5)

    return ret

no_proxy = env.get('no_proxy', None) or env.get('NO_PROXY', None) or ''
proxy_info = {}
maven_proxy = ''
for protocol in ['http', 'https']:
    proxy_info[protocol] = get_proxy(protocol)
    if proxy_info[protocol] is None:
        continue

    if 'username' in proxy_info[protocol]:
        auth = proxy_auth % (proxy_info['http']['username'],
                             proxy_info['http']['password'])
    else:
        auth = ''

    maven_proxy += maven_template % ('%sproxy' % protocol,
                                    protocol,
                                    proxy_info['http']['host'],
                                    proxy_info['http']['port'],
                                    auth,
                                    no_proxy.replace(',', '|')
                                    )

if maven_proxy != '':
    maven_settings = '<settings>\n' + maven_proxy + '</settings>'
    with open('settings.xml', 'w') as f:
        f.write(maven_settings)

env_file = None
if no_proxy != '':
    env_file = 'no_proxy=%s\nNO_PROXY=%s\n' % (no_proxy, no_proxy)
if proxy_info['http'] is not None:
    env_file += 'http_proxy=%s\nHTTP_PROXY=%s\n' % (proxy_info['http']['url'],
                                                    proxy_info['http']['url'])
if proxy_info['https'] is not None:
    env_file += 'https_proxy=%s\nHTTPS_PROXY=%s\n' % (proxy_info['https']['url'],
                                                      proxy_info['https']['url'])

if env_file is not None:
    with open('environment', 'w') as f:
        f.write(env_file)






















