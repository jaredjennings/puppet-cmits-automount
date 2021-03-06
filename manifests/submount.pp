# % CMITS - Configuration Management for Information Technology Systems
# % Based on <https://github.com/afseo/cmits>.
# % Copyright 2015 Jared Jennings <mailto:jjennings@fastmail.fm>.
# %
# % Licensed under the Apache License, Version 2.0 (the "License");
# % you may not use this file except in compliance with the License.
# % You may obtain a copy of the License at
# %
# %    http://www.apache.org/licenses/LICENSE-2.0
# %
# % Unless required by applicable law or agreed to in writing, software
# % distributed under the License is distributed on an "AS IS" BASIS,
# % WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# % See the License for the specific language governing permissions and
# % limitations under the License.
# \subsection{Define mounts under subdirectories}
#
# Whatever you give as the under value for this define, you must have
# an \verb!automount::subdir! define for.
# See~\S\ref{define_automount::subdir}
# and~\S\ref{define_automount::mount}.

define automount::submount($under, $from, $ensure='present') {
    include automount

    case $::osfamily {
        'RedHat': {
            automount::mount::redhat { $name:
                from => $from,
                under => $under,
                ensure => $ensure,
            }
        }
        'Darwin': {
# \implements{unixsrg}{GEN002420,GEN005900} Ensure the \verb!nosuid! option
# is used when mounting an NFS filesystem.
#
# \implements{unixsrg}{GEN002430} Ensure the \verb!nodev! option is used when
# mounting an NFS filesystem.
            mac_automount { "/net/${under}/${name}":
                source => $from,
                ensure => $ensure,
                options => ['nodev', 'nosuid', 'nolock'],
                notify => Service['com.apple.autofsd'],
            }
        }
        default: { fail "unimplemented on ${::osfamily}" }
    }
}
