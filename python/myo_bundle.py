import re
import abc

from amino import _, __, List, Try, L, Map, Just
from amino.lazy import lazy

from myo.output.parser.python import FileEntry
from ribosome.util.callback import VimCallback


class FirstErrorPy(VimCallback):

    @lazy
    def pkg(self):
        return Try(lambda: self.vim.vars('project_name')).join | ''

    @lazy
    def rex(self):
        return re.compile(r'\b{p}/{p}/'.format(p=self.pkg))

    def __call__(self, lines):
        match = lambda line: self.rex.search(line.text)
        return lines.reversed.index_where(match) / (lines.length - _)


class FilterPy(VimCallback):

    @lazy
    def packages(self):
        pkg = Try(lambda: self.vim.vars('project_name')).join | ''
        am_pkgs = List() if pkg == 'amino' else List('amino')
        ribo_pkgs = List() if pkg == 'ribosome' else List('ribosome')
        return am_pkgs + ribo_pkgs + List('sure', 'nose', 'unittest')

    @lazy
    def package_re(self):
        rex = '/({}|site-packages|python\d\.\d)/{}/'
        return self.packages / (lambda a: rex.format(a, a)) / re.compile

    def _hide_path(self, entry):
        return isinstance(entry, FileEntry) and self._match_path(entry.path)

    def _match_path(self, path):
        p = str(path)
        return self.package_re.exists(__.search(p))

    def _filter_event(self, events):
        return events.modder.entries(__.filter_not(self._hide_path))

    def __call__(self, r):
        return r.modder.events(_ / self._filter_event)

_trunc_re1 = re.compile('.*/code(_ext)?/python(_nvim)?/')
_trunc_re2 = re.compile('.*/site-packages/')
_trunc_re3 = re.compile('.*/python3\.5/')


def truncate_py(path):
    p1 = _trunc_re1.sub('', str(path))
    p2 = _trunc_re2.sub('site/', p1)
    p3 = _trunc_re3.sub('lib/', p2)
    return p3


class SbtProjectCmd(VimCallback, metaclass=abc.ABCMeta):

    @property
    def projects(self):
        return self.vim.vars('sbt_project_map') / Map | Map()

    @property
    def current(self):
        return self.vim.vars('sbt_project')

    def conf(self, key, pro, cmd):
        return (self.projects.get(pro) // __.get(key) // __.get(cmd)).o(
            self.projects.get('default') // __.get(key) // __.get(cmd)
        )

    def effective_command(self, pro, cmd):
        return self.conf('command', pro, cmd)

    def scope(self, pro, name):
        return self.conf('scope', pro, name)

    def scoped(self, pro, name, cmd):
        return self.scope(pro, name) / L('{}:{}'.format)(_, cmd)

    def format(self, pro, name):
        cmd = self.effective_command(pro, name) | name
        scoped = self.scoped(pro, name, cmd) | cmd
        pre = '{}/'.format(pro) if pro else ''
        return '{}{}'.format(pre, scoped)

    def __call__(self, cmd):
        return (self.current / L(self.format)(_, cmd)).o(Just(cmd))


def chain_sbt(names):
    return ''.join([';{}'.format(name) for name in names])


def chain_shell(names) -> str:
    return ' && '.join(names)

__all__ = ('FilterPy', 'truncate_py', 'FirstErrorPy', 'SbtProjectCmd')
