function go(){
declare -- sn=$1;

if [[ $sn =~ .*trans|temp|\.|\/.* ]] ;
 then
 	cd "$sn";
else

declare -a found;
for dir in "/home/gmi/v2/gmi/v3/AMS" "/home/gmi/v2/gmi/v2" "/home/gmi/v2/bor/v1/AG" "/home/gmi/v2/lsr/bmr/v3" "/home/gmi/v2/lsr/bmr/v2" "/home/gmi/v2/gmi/v3/AMS/INTERNAL" "/home/gmi/v2/gmi" "/home/gmi/v2/gmi/v2/maps" "/home/gmi/v2/gmi/v3/AMS/NATO" "/home/gmi/v2/gmi/v2/NATO" ; do
 if [ -d "$dir/$sn" ];
  then
   found+=("$dir/$sn");
 fi
done;

declare -- idx=0;
if [ ${#found[@]} -gt 1 ];
 then
  for item in ${found[@]};  do
    idx=$((idx+1));
    echo $idx': ' $item;
  done;
   read -p "Enter the number of the directory to go to: " dirNum
   echo "${found[$dirNum-1]}";
   cd "${found[$dirNum-1]}";
elif [ ${#found[@]} -eq 1 ];
 then
   echo "${found[0]}";
   cd "${found[0]}";
else
  for line in $(find /home/gmi/v2 ! -readable -prune -o -name $sn -a -type d -print); do
    echo "$line";
    cd "$line";
  done;
fi;

fi;
};
