# Reminder: use by running `:SortByHeader *` (e.g. for AsciiDoc lists).
Neovim.plugin do |plug|
  plug.command(:SortByHeader, nargs: 1, range: true) do |nvim, str|
    buffer = nvim.current.buffer
    start = buffer.get_mark("<").first - 1
    last  = buffer.get_mark(">").first
    lines = buffer.get_lines(start, last, false)

    changed = lines.each_with_object([]) do |line, result|
      if line.start_with?(str)
        result << line+'\0'
      else
        # TODO: If the first line is not a header, result will be empty.
        last = result.pop
        result << last+line+'\0'
      end
    end.sort.flat_map { |line| line.split('\0') }

    # TODO: causes one change per line (harder to undo), but I can't find any
    # API for doing it in one go.
    changed.each_with_index do |item, index|
      buffer[start + index + 1] = item
    end

  end
end

