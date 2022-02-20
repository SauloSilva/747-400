today=`date '+%Y/%m/%d %H:%M'`;
versionid="XP1150-$today";
versionline="fmcVersion=\"$versionid\"";
echo $versionline >> plugins/xtlua/scripts/B747.68.xt.fms/activepages/version.lua
pandoc -o README.pdf README.md
git add --all
