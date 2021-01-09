################################################################################
#                                  $HOME/opt                                   #
################################################################################

if [ -d /usr/lib/debian-med/bin ]
then
   export PATH="/usr/lib/debian-med/bin:$PATH"
fi

AUTOPATH_PREFIXES=( "$HOME" "$HOME/opt" "$HOME/.local" "$HOME/.dots")

for prefix in "${AUTOPATH_PREFIXES[@]}"
do

    if [ -d "$prefix/bin" ] ; then
        export PATH="$prefix/bin:$PATH"
    fi

    if [ -d "$prefix/lib" ] ; then
        export LD_LIBRARY_PATH="$prefix/lib:$LD_LIBRARY_PATH"
    fi

    if [ -d "$prefix/include" ] ; then
        export CPATH="$prefix/include:$CPATH"
        export C_INCLUDE_PATH="$prefix/include:$C_INCLUDE_PATH"
        export CPLUS_INCLUDE_PATH="$prefix/include:$CPLUS_INCLUDE_PATH"
    fi

    if [ -d "$prefix/lib/pkgconfig" ] ; then
        export PKG_CONFIG_PATH="$prefix/lib/pkgconfig:$PKG_CONFIG_PATH"
    fi

    if [ -d "$prefix/share/man" ] ; then
        export MANPATH="$prefix/share/man:$MANPATH"
    fi

done

test -f "$HOME/.homedir/profile.sh" && source "$HOME/.homedir/profile.sh"
test -f "$HOME/.zshenv.local" && source "$HOME/.zshenv.local"
