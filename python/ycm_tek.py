__copyright__ = """ Copyright (c) 2013 Torsten Schmits

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 3 of the License, or (at your
option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, see <http://www.gnu.org/licenses/>.
"""

from ycm.completers.python.jedi_completer import JediCompleter

from tek_vim import line
from tek_vim_py_inspect import containing_function

class PythonCompleter(JediCompleter):

    def _function_args(self):
        func = containing_function(line())
        return (a.id for a in func.args.args[1:]) if func else []

    def ComputeCandidates(self, unused_query, unused_start_column):
        item = lambda a: dict(word='_{}'.format(a),
                              menu='function parameter',
                              kind='v')
        args = map(item, self._function_args())
        jedi = super(PythonCompleter, self).ComputeCandidates(0, 0)
        return args + jedi

def register(ycm_state):
    ycm_state.filetype_completers['python'] = PythonCompleter()

__all__ = ['PythonCompleter']
