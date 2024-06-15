#==============================================================================#
#                             (P)retty(C)omments.JL                            #
#==============================================================================#
#   Quickly format comments to better distinguish between different parts of a
#   program. 
#
#   REVISIONS:
#     Date       Version                         Changes
#   ========    =========  ====================================================
#   30/05/24       0.0     prettycomment, bigheader, filepreamble
#   05/06/24       1.0     Fully functional. f95comment. 
#   06/06/24       1.1     issues(), filepreamble(name)→preamble(name,desc)
#   11/06/24       1.2     added comments, fixed odd/even length issues
#   14/06/24       2.0     renamed & commented everything, bugfixes
#==============================================================================#

using Dates
using InteractiveUtils

"""
    line(sep::Char = '=')
Return and copy to clipboard an 80 character string starting and ending with *#*, 
filled with the seperator character, *sep*.
"""
function line(sep::Char='=')
    s = '#' * sep^78 * '#'
    s
end

"""
    divider(str::String, sep::Char = '=')
Return and copy to clipboard *str* centered in a line of *sep* characters as a
comment.

## Example
julia> divider 
julia> divider
"""
function divider(str::String, sep='=')
    msg = uppercase(str)
    len = length(msg) + 4
    n = (80 - len) ÷ 2
    # test if msg too long to put on one line
    if len > 80
        @warn "message length is too long and create a weird divider" msg
    end
    # center text and pad both sides with sep
    if length(msg) % 2 == 0
        h = '#' * sep^n * " $msg " * sep^n * '#'
    else
        h = "#"* sep * sep^n * " $msg " * sep^n * '#'
    end
    clipboard(h)
    h
end

"""
    divider(sep::Char = '=')
Convert a string on the clipboard to a centered divider comment line.
"""
function divider(sep='=')
    str = clipboard()
    msg = uppercase(str)
    len = length(msg) + 4
    # test for overflowing 80ch.
    if len > 80
        @warn "message length too long, will make a weird divider"
    end
    n = (80 - len) ÷ 2
    if length(msg) % 2 == 0
        h = '#' * sep^n * " $msg " * sep^n * '#'
    else
        h = "#=" * sep^n * " $msg " * sep^n * '#'
    end
    clipboard(h)
end


"""
    header(str::String, sep='=')
Copy to clipboard a centered *str* surrounded above and below with lines.
"""
function header(str::String, sep='=')
    l = line(sep)
    msg = divider(str, ' ')
    s = "$l\n$msg\n$l"
    clipboard(s)
end

"""
    header(str::String, sep='=')
Convert a string on the clipboard to a centered centered *str* surrounded above
and below with lines.
"""
function header(sep='=')
    str = clipboard()
    l = line(sep)
    msg = divider(str, ' ')
    s = "$l\n$msg\n$l"
    clipboard(s)
end

"""
    wraptext(str::String, tabstop=4)
Format a *str* to wrap lines every 80 characters.
"""
function wraptext(str::String, tabstop=4)
    str = split(str, ' ')
    i = 2
    s = "# "
    # concatenate words to s unless it would overflow 80ch, in which case 
    #   continue on new line and indent.
    for word in str
        r = length(word)
        if i + r + 1 < 80
            s = s * ' ' * word
            i += r + 1
        else
            s = s * "\n#\t" * word
            i = tabstop + r + 1
        end
    end
    s
end

"""
    pc(str::String, tabstop=4)
Copy to clipboard *str* as a comment in the standard .f95 style.
"""
function pc(str::String, tabstop=4)
    msg = uppercase(str)
    s = wraptext(msg)
    out = "#\n" * s * "\n#"
    clipboard(out)
end

"""
    pc(tabstop=4)
Convert *str* from the clipboard to a comment in the standard .f95 style.
"""
function pc(tabstop=4)
    str = clipboard()
    msg = uppercase(str)
    s = wraptext(msg)
    out = "#\n" * s * "\n#"
    clipboard(out)
end


"""
    issues()
Copy to clipboard a template for listing current issues.
"""
function issues()
    l = line()
    d = divider("current issues")
    str = "$d \n" * "# - \n"^3 * "$l\n"
    clipboard(str)
end

"""
    preamble(filename::String, description::String)
Copy to clipboard a .jl/.py file preamble for *filename* containing its date of
creation and a brief *description* of its purpose.
"""
function preamble(filename::String, description::String)
    l = line()
    date = Dates.format(today(), "dd/mm/yy")
    head = divider(filename, ' ')
    desc = wraptext(description)
    str = """
    $l
    $head
    $l
    $desc
    #
    #   REVISIONS:
    #     Date       Version                         Changes
    #   ========    =========  ====================================================
    #   $date       0.0     
    $l
    $l
    """
    clipboard(str)
end