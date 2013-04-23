#! /bin/bash
#basepath=$(greadlink -f $(pwd))
basepath=$(hg root)
#yikes some compex bashery
while IFS= read -d $'\0' -r file ; do
      relfile=${file/$basepath/.}
      cksum=$(sha1sum "$file" | cut -d ' ' -f 1)
     
      mdls -name kMDItemWhereFroms "$file" | gawk -v fi="$relfile" -v sum=$cksum\
      	   'function trim(s) {return gensub(/^[ ]*"([^"]*)"[,]?[ ]*$/, "\\1", "g", s) }; \
            BEGIN{RS="";FS="\n";OFS="\t"}; \
            {print sum,fi,trim($2),trim($3)}'
done < <(mdfind -0 -onlyin . "kMDItemWhereFroms == *") | sort