import sure  # NOQA
from flexmock import flexmock  # NOQA
from tek import Config  # NOQA
from tek.test import Spec
import tests  # NOQA


class <pythontestname>(Spec, ):

    def setup(self, *a, **kw):
        super(<pythontestname>, self).setup(*a, **kw)

    def test(self):
        <+CURSOR+>pass

__all__ = ['<pythontestname>']
