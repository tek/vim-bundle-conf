from amino import _, __, L, List

from myo.output.parser.python import FileEntry


def _is_spec_entry(entry):
    return isinstance(entry, FileEntry) and 'unittest' in str(entry.path)


def _is_spec_trace(event):
    return event.entries.exists(_is_spec_entry)


def _remove_spec_trace(events):
    return events[:-1] if events.last.exists(_is_spec_trace) else events


def _find_line(lines, entry):
    from ribosome.logging import log
    log.verbose(entry)
    return lines.index_where(_.target == entry)


def first_error(result):
    from ribosome.logging import log
    events = (_remove_spec_trace(result.events) if result.events.length > 1
              else result.events)
    entry = (
        events.last /
        _.entries.reversed //
        __.find(L(isinstance)(_, FileEntry))
    )
    log.verbose(entry)
    lines = result.lines | List()
    line = entry // L(_find_line)(lines, _)
    log.verbose(line)
    return line / (lambda a: (a + 1, 1))

__all__ = ('first_error',)
