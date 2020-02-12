#!/usr/bin/perl
if (!$ARGV[0]) {
	print "\nUSAGE: illumina_16S_collect.pl dir [dir] [dir]\n\n";
	print "   This script loads Illumina summary reports (obtained by direct reads classification)\n";
	print "   and creates independent count files for the different taxonomic ranks.\n\n";
	exit;
}
foreach $d (@ARGV) {
	opendir (DIR,$d);
	foreach $file (readdir DIR) {
		next if ($file !~ /\.summary\.txt/);
		$name = $file;
		$name =~ s/\.summary.txt//;
		push(@names, $name);
		print STDERR "Reading $file in $d ...";
		$lines = 0;
		open(IN,"$d/$file");
		$cnt = 0;
		while ($line = <IN>) {
			chomp $line;
			$cnt++;
			next if ($cnt <= 3);
			$lines++;
			@tmp = split (/[;\t]/,$line);
			$perc = pop @tmp;
			$num = pop @tmp;
			if ($tmp[0] =~ /\w/) {
				$cnt{"d.$name.".$tmp[$0]}+= $num;
				$d{$tmp[$0]} = 1;
			}
			if ($tmp[1] =~ /\w/) {
				$cnt{"p.$name.".$tmp[1]}+= $num;
				$p{$tmp[1]} = 1;
			}
			if ($tmp[2] =~ /\w/) {
				$cnt{"c.$name.".$tmp[2]}+= $num;
				$c{$tmp[2]} = 1;
			}
			if ($tmp[3] =~ /\w/) {
				$cnt{"o.$name.".$tmp[3]}+= $num;
				$o{$tmp[3]} = 1;
			}
			if ($tmp[4] =~ /\w/) {
				$cnt{"f.$name.".$tmp[4]}+= $num;
				$f{$tmp[4]} = 1;
			}
			if ($tmp[5] =~ /\w/) {
				$cnt{"g.$name.".$tmp[5]}+= $num;
				$g{$tmp[5]} = 1;
			}
			if ($tmp[6] =~ /\w/) {
				$cnt{"s.$name.".$tmp[6]}+= $num;
				$s{$tmp[6]} = 1;
			}
		}
		print STDERR "$lines rows\n";
	}
}

open(D,">domain.txt");
print D "Name\t",(join "\t", @names),"\n";
foreach $org (sort keys %d) {
	print D $org;
	#print STDERR "-",$org;
	foreach $name (@names) {
		print D "\t",$cnt{"d.$name.".$org} if ($cnt{"d.$name.".$org});
		print D "\t0" if (!$cnt{"d.$name.".$org});
	}
	print D "\n";
}
close D;

open(P,">phylum.txt"); 
print P "Name\t",(join "\t", @names),"\n";
foreach $org (sort keys %p) {
	print P $org;
	foreach $name (@names) {
		print P "\t",$cnt{"p.$name.".$org} if ($cnt{"p.$name.".$org});
		print P "\t0" if (!$cnt{"p.$name.".$org});
	}
	print P "\n";
}
close P;

open(C,">class.txt"); 
print C "Name\t",(join "\t", @names),"\n";
foreach $org (sort keys %c) {
	print C $org;
	foreach $name (@names) {
		print C "\t",$cnt{"c.$name.".$org} if ($cnt{"c.$name.".$org});
		print C "\t0" if (!$cnt{"c.$name.".$org});
	}
	print C "\n";
}
close C;

open(O,">order.txt");
print O "Name\t",(join "\t", @names),"\n";
foreach $org (sort keys %o) {
	print O $org;
	foreach $name (@names) {
		print O "\t",$cnt{"o.$name.".$org} if ($cnt{"o.$name.".$org});
		print O "\t0" if (!$cnt{"o.$name.".$org});
	}
	print O "\t";
}
close O;

open(F,">family.txt"); 
print F "Name\n",(join "\t", @names),"\n";
foreach $org (sort keys %f) {
	print F $org; 
	foreach $name (@names) {
		print F "\t",$cnt{"f.$name.".$org} if ($cnt{"f.$name.".$org});
		print F "\t0" if (!$cnt{"f.$name.".$org});
	}
	print F "\n";
}
close F;

open(G,">genus.txt");
print G "Name\t",(join "\t", @names),"\n";
foreach $org (sort keys %g) {
	print G $org; 
	foreach $name (@names) {
		print G "\t",$cnt{"g.$name.".$org} if ($cnt{"g.$name.".$org});
		print G "\t0" if (!$cnt{"g.$name.".$org});
	}
	print G "\n";
}
close G;

open(S,">species.txt");
print S "Name\t",(join "\t", @names),"\n";
foreach $org (sort keys %s) {
	print S $org;  
	foreach $name (@names) {
		print S "\t",$cnt{"s.$name.".$org} if ($cnt{"s.$name.".$org});
		print S "\t0" if (!$cnt{"s.$name.".$org});
	}
	print S "\n";
}
close S;
