GREEN='\033[0;32m'
YELLOW='\033[1;33m'
LRED='\033[1;31m'
LBLUE='\033[1;34m'
NC='\033[0m'

echo -e "${NC}Regex: ${GREEN}$1"
echo -e "${NC}File Type: ${GREEN}$2"
echo ""

changes=0

for file in *."$2"; do
    title=`expr "$file" : "\($1\)"`;
    title=$(tr '.' ' ' <<<$title);

    if [ "$title" = "" ]
    then
        echo -e "${NC}\"$file\" ${LBLUE}will be skipped";
    else
        if [ -f "$title.$2" ]
        then
            echo -e "${NC}${NC}\"$file\" ${LRED}will be skipped cause ${NC}\"$title.$2\" ${LRED}already exist";
        else
            echo -e "${NC}${NC}\"$file\" ${GREEN}will become ${NC}\"$title.$2\"";
            changes+=1
        fi
    fi
done

if [ "$changes" != "0" ]
then
    echo ""
    echo -e "${NC}Continue (${GREEN}y${NC}/${LRED}N${NC})?"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ]; then
        echo " " >> lastest.log;
        date=`date '+%d/%m/%Y - %H:%M:%S'`;
        echo "===> Start Log at ($date) <===" >> lastest.log;
        for file in *."$2"; do
            title=`expr "$file" : "\($1\)"`;
            title=$(tr '.' ' ' <<<$title);

            if [ "$title" = "" ]
            then
                echo -e "${NC}\"$file\" ${LBLUE}skipped";
            else
                date=`date '+%d/%m/%Y - %H:%M:%S'`;

                if [ -f "$title.$2" ]
                then
                    echo "($date) \"$title.$2\" already exist, \"$file\" skipped to don't replace the file" >> lastest.log;
                    echo -e "${NC}\"$file\" ${LRED}won't change cause ${NC}\"$title.$2\" ${LRED}already exist";
                else
                    echo "($date) \"$title.$2\" previously \"$file\"" >> lastest.log;
                    echo -e "${NC}\"$title.$2\" ${GREEN}previously ${NC}\"$file\"";
                    mv "$file" "$title.$2";
                fi
            fi
        done
        date=`date '+%d/%m/%Y - %H:%M:%S'`;
        echo "===> Stop Log at ($date) <===" >> lastest.log;
    else
        echo -e "${GREEN}Canceled, No file will be changed."
    fi
else
    echo ""
    echo -e "${GREEN}Canceled, No file detected for changes."
fi

# "La\.Casa\.De\.Papel\.S01E[0-9]*"
# date '+%d/%m/%Y - %H:%M:%S'