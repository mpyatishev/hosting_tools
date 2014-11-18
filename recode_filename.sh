find ./ -name "Ð*" -depth 1 | sed -E 's/ /\\\\ /g' | xargs -I % sh -c 'echo -n "% "; echo %|iconv -c -f UTF-8 -t KOI8-R|sed -E "s/ /\\\\ /g"'
