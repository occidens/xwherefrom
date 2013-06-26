#! /bin/bash
basepath=$(greadlink -f $(pwd))

#yikes some compex bashery
while IFS= read -d $'\0' -r file ; do
      relfile=${file/$basepath/.}

      URL=$(mdls -name kMDItemWhereFroms "$file" | gawk -v fi="$relfile" \
      	   'function trim(s) {return gensub(/^[ ]*"([^"]*)"[,]?[ ]*$/, "\\1", "g", s) }; \
            BEGIN{RS="";FS="\n";OFS="\t"}; \
            {print trim($2)}')
      if [ -z "$URL" ]
      then
	  echo "$relfile has no kMDItemWhereFroms data"
      else
          git annex addurl --file "$relfile" $URL
      fi

done < <(find . -type l -print0) | sort
