# good experience with svn.
export SVN_EDITOR=vim
alias st='svn st'
alias sd='svn diff'
alias sdv='svn diff|gvim -R -'
svnremovedeletedfiles()
{
    svn st|awk '/^!/ {print $2}'|sed 's#\\#\/#g'|while read -r file;
do
    svn remove --force "$file"
done
}
svnadduntrackedfiles()
{
    svn st|awk '/^?/ {print $2}'|sed 's#\\#\/#g'|xargs svn add --force
}
svnremoveaddedfiles()
{
    svn st|awk '/^A/ {print $2}'|tac|sed 's#\\#\/#g'|while read -r file;
do
    svn remove --keep-local --force "$file"
done
}
svnrepourl()
{
    svn info "$*"| grep URL|sed -e s/URL:\ //g
}
