############
#### GO ####
############
function go(){
declare -- sn=$1;


if [[ $sn =~ trans|temp-|.*\.|.*\/.* ]] ;
 then
   if [ -d "$sn" ]; then 
     cd "$sn";
   elif [ -d /home/hermes/v2/"$sn" ]; then
     cd /home/hermes/v2/"$sn";
   elif [ -d /home/hermes/v2/gmi/"$sn" ]; then
     cd /home/hermes/v2/gmi/"$sn";
   else
     echo "Sorry, didn't find where to go!"
     return 1
   fi
else

 declare -a found;
 for dir in "/home/hermes/v2/gmi/v3/AMS" "/home/hermes/v2/gmi/v2" "/home/hermes/v2/bor/v1/AG" "/home/hermes/v2/lsr/bmr/v3" "/home/hermes/v2/lsr/bmr/v2" "/home/hermes/v2/gmi/v3/AMS/INTERNAL" "/home/hermes/v2/gmi" "/home/hermes/v2/gmi/v2/maps" "/home/hermes/v2/gmi/v3/AMS/NATO" "/home/hermes/v2/gmi/v2/NATO" ; do
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
   declare -a foundm;
   for line in $(find /home/hermes/v2 ! -readable -prune -o -name $sn -a -type d -print); do
     foundm+=("$line");
   done;

   declare -- idm=0;
   if [ ${#foundm[@]} -gt 1 ];
    then
     for item in ${foundm[@]};  do
       idm=$((idm+1));
       echo $idm': ' $item;
     done;
      read -p "Enter the number of the directory to go to: " dirNum
      echo "${foundm[$dirNum-1]}";
      cd "${foundm[$dirNum-1]}";
   elif [ ${#foundm[@]} -eq 1 ];
    then
      echo "${foundm[0]}";
      cd "${foundm[0]}";
      
   fi;

 fi;

fi;
};
