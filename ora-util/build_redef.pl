#!/usr/bin/perl -w

use strict;
use File::Basename;
use File::Copy;
use File::Path;


sub register_dependent
{
    my $schema = shift;
    my $table = shift;
    my $interim = shift;
    my $orig_name = shift;
    my $int_name = shift;
    my $cons_type = shift;
    my $type;

    if ($cons_type =~ "P")
    {
        $type = "dbms_redefinition.cons_constraint";
    }
    else
    {
        $type = "dbms_redefinition.cons_index";
    }

    print("\nprompt dbms_redefinition.register_dependent_object $schema $orig_name\n");

    print "\nbegin\n"; 
    print "  dbms_redefinition.register_dependent_object(\n";
    print "      uname => '$schema',\n"; 
    print "      orig_table => '$table',\n"; 
    print "      int_table => '$interim',\n"; 
    print "      dep_type => $type,\n"; 
    print "      dep_owner => '$schema',\n"; 
    print "      dep_orig_name => '$orig_name',\n"; 
    print "      dep_int_name => '$int_name');\n"; 
    print "end;\n"; 
    print "/\n\n"; 
}


sub copy_dependents
{
    my $schema = shift;
    my $table = shift;
    my $interim = shift;

    print("\nprompt dbms_redefinition.copy_table_dependents $schema $table $interim\n");

    print "\ndeclare\n"; 
    print "  num_errors number(10);\n"; 
    print "begin\n"; 
    print "  dbms_redefinition.copy_table_dependents(\n";
    print "      uname => '$schema',\n"; 
    print "      orig_table => '$table',\n"; 
    print "      int_table => '$interim',\n"; 
    print "      copy_indexes => dbms_redefinition.cons_orig_params,\n"; 
    print "      copy_triggers => true,\n"; 
    print "      copy_constraints => true,\n"; 
    print "      copy_privileges => true,\n"; 
    print "      ignore_errors => true,\n"; 
    print "      num_errors => num_errors,\n"; 
    print "      copy_statistics => false,\n"; 
    print "      copy_mvlog => true);\n"; 
    print "end;\n"; 
    print "/\n\n"; 
}

sub parse_index_file
{
    my $file;
    my $line;

    my @indexes = ();

    if (!open($file, "<", "_tab_indexes_.txt"))
    {
        print "unable to open file for indexes\n";
        return;
    }
   
    while ($line = <$file>)
    {
        $line =~ s/\W+$//;
        next if ($line =~ "=");
        my @fields = split(',', $line);
        my %record = (
            owner => $fields[0],
            name => $fields[1],
            type => $fields[2]);
        push(@indexes, \%record);
    }

    close($file);
    return \@indexes;
}

sub parse_cons_file
{
    my $file;
    my $line;

    my @cons= ();

    if (!open($file, "<", "_tab_cons_.txt"))
    {
        print "unable to open file for constraints\n";
        return;
    }
   
    while ($line = <$file>)
    {
        $line =~ s/\W+$//;
        next if ($line =~ "=");
        my @fields = split(',', $line);
        my %record = (
            owner => $fields[0],
            tab => $fields[1],
            type => $fields[2],
            name => $fields[3],
            col => $fields[4],
            pos => $fields[5],
            r_tab => $fields[6],
            r_col => $fields[7],
            tbsp => $fields[8]);
        push(@cons, \%record);
    }

    close($file);
    return \@cons;
}

sub rebuild_indexes
{
    my $tbsp = shift;
    my $indexes = shift;

    foreach my $index (@$indexes)
    {
        my $owner = $$index{owner};
        my $name = $$index{name};
        print "alter index ${owner}.${name} rebuild tablespace $tbsp online;\n";
    }
}

sub get_redef_options
{
    my $cons = shift;
    my $pk;
    my $options;

    foreach my $con (@$cons)
    {
        if ($$con{type} eq "P")
        {
            $pk = $$con{name};
        }
    }

    if ($pk)
    {
        $options = "dbms_redefinition.cons_use_pk";
    }
    else
    {
        $options = "dbms_redefinition.cons_use_rowid";
    }

    return $options;
}

sub generate_abort_redef
{
    my $schema = shift;
    my $table = shift;
    my $interim = shift;

    print("\nbegin\n");
    print("  dbms_redefinition.abort_redef_table(\n");
    print("    uname => '$schema',\n");
    print("    orig_table => '$table',\n");
    print("    int_table => '$interim');\n");
    print("end;\n");
    print("/\n\n");
}

sub sync_interim
{
    my $schema = shift;
    my $table = shift;
    my $interim = shift;

    print("\nprompt dbms_redefinition.sync_interim_table $schema $table $interim\n");

    print("\nbegin\n");
    print("  dbms_redefinition.sync_interim_table(\n");
    print("    uname => '$schema',\n");
    print("    orig_table => '$table',\n");
    print("    int_table => '$interim');\n");
    print("end;\n");
    print("/\n\n");
}

sub can_redef
{
    my $schema = shift;
    my $table = shift;
    my $options = shift;

    print("\nprompt dbms_redefinition.can_redef_table $schema $table $options\n");

    print("\nbegin\n");
    print("  dbms_redefinition.can_redef_table(\n");
    print("    uname => '$schema',\n");
    print("    tname => '$table',\n");
    print("    options_flag => $options);\n");
    print("end;\n");
    print("/\n\n");
}

sub pre_redef
{
    print("\nselect instance_name from v\$instance;\n");
    print("\nselect sysdate from dual;\n");
}

sub finish_redef
{
    my $schema = shift;
    my $table = shift;
    my $interim = shift;

    print("\nprompt dbms_redefinition.finish_redef_table $schema $table $interim\n");

    print("\nbegin\n");
    print("  dbms_redefinition.finish_redef_table(\n");
    print("    uname => '$schema',\n");
    print("    orig_table => '$table',\n");
    print("    int_table => '$interim');\n");
    print("end;\n");
    print("/\n\n");
}

sub generate_start_redef
{
    my $schema = shift;
    my $table = shift;
    my $interim = shift;
    my $options = shift;

    print("\nprompt dbms_redefinition.start_redef_table $schema $table $interim\n");

    print("\nbegin\n");
    print("  dbms_redefinition.start_redef_table(\n");
    print("    uname => '$schema',\n");
    print("    orig_table => '$table',\n");
    print("    int_table => '$interim',\n");
    print("    options_flag => $options);\n");
    print("end;\n");
    print("/\n\n");
}


sub register_indexes
{
    my $schema = shift;
    my $table = shift;
    my $interim = shift;
    my $indexes = shift;

    foreach my $index (@$indexes)
    {
        my $index_name = $$index{name};

        register_dependent($schema, $table, $interim, $index_name, $index_name . "_NEW", $$index{type});
       
        if ($$index{type} =~ "P")
        {
            register_dependent($schema, $table, $interim, $index_name, $index_name . "_NEW", lc($$index{type}));
        }

    }
}

sub build_script
{
    my $schema = shift;
    my $table = shift;
    my $interim = shift;
    my $tbsp_dat = shift;
    my $tbsp_idx = shift;
    
    my $cons = parse_cons_file();
    my $options = get_redef_options($cons);
    my $indexes = parse_index_file();
    my $columns = parse_tab_cols();

    pre_redef();

    can_redef($schema, $table, $options);
    create_int_table($schema, $interim, $columns);
    generate_table_ddl($schema, $table, $interim);
    generate_start_redef($schema, $table, $interim, $options);

    if ($tbsp_idx)
    {
        register_indexes($schema, $table, $interim, $indexes);
    }

    copy_dependents($schema, $table, $interim);
    sync_interim($schema, $table, $interim);
    finish_redef($schema, $table, $interim);

    if ($tbsp_idx)
    {
        #rebuild_indexes($tbsp_idx, $indexes);
    }

    print "\nprompt drop table $schema\.$interim cascade constraints;\n\n";
    print "\ndrop table $schema\.$interim cascade constraints;\n\n";

    generate_abort_redef($schema, $table, $interim);
}

sub generate_table_ddl
{
    my $schema = uc(shift);
    my $table = uc(shift);
    my $interim = uc(shift);

    my $filename = "${schema}_${table}\.txt";
    my $file;
    my $line;
    my $buf = "";
    my $buf1 = "";
    my $buf2 = "";
    my $pos;

    if (!open($file, "<", $filename))
    {
        print "unable to open file $filename";
        return;
    }

    print("\nprompt create table $schema.$interim\n");


    while ($line = <$file>)
    {
        $line =~ s/^\t//;
        $line =~ s/^ +//;
        $line =~ s/ +$//;
        $line =~ s/\n//;

        next if ($line =~ /^$/ || $line =~ ':');

        if ($line =~ /^CREATE TABLE/)
        {
            $buf = $line;
        }
        elsif ($line !~ /PL\/SQL/)
        {
            $buf = $buf . " " . $line;
        }
    }
    close($file);


    $pos = index($buf, "SEGMENT CREATION");
    $buf1 = substr($buf, 0, $pos); 
    $buf2 = substr($buf, $pos);

    $buf1 =~ s/\(\t/\n\(\n  /g;
    $buf1 =~ s/ CONSTRAINT .*? NOT NULL ENABLE NOVALIDATE/ NOT NULL/g;
    $buf1 =~ s/ NOT NULL ENABLE/ NOT NULL/g;
    $buf1 =~ s/(CONSTRAINT .*?ENABLE,)//g;
    $buf1 =~ s/(CONSTRAINT .*?ENABLE)//g;
    $buf1 =~ s/(PRIMARY KEY .*?ENABLE)//g;
    $buf1 =~ s/\, +\)/\n\)/g;
    $buf1 =~ s/\ +\)/\n\)/g;
    $buf1 =~ s/\, \"/\,\n  \"/g;
    $buf1 =~ s/\"//g;
    $buf1 =~ s/$schema\.$table/$schema\.$interim/;

    $buf2 =~ s/(STORAGE\(.*?\))//g;
    $buf2 =~ s/ COMPRESS /\nCOMPRESS /g;
    $buf2 =~ s/ TABLESPACE /\nTABLESPACE /g;
    $buf2 =~ s/ LOB \(/\nLOB \(/g;
    $buf2 =~ s/SEGMENT CREATION.*//g;
    $buf2 =~ s/\"//g;

    print "\n$buf1";
    print "$buf2\n;\n";

}

sub parse_tab_cols
{
    my $file;
    my $line;

    my @cols= ();

    if (!open($file, "<", "_tab_cols_.txt"))
    {
        print "unable to open file for columns\n";
        return;
    }
   
    while ($line = <$file>)
    {
        $line =~ s/\W+$//;
        next if ($line =~ "=");
        my @fields = split(',', $line);
        my %record = (
            owner => $fields[0],
            tab => $fields[1],
            name => $fields[2],
            data_type => $fields[3],
            data_len => $fields[4],
            data_precision => $fields[5],
            data_scale => $fields[6],
            nullable => $fields[7]);
        push(@cols, \%record);
    }

    close($file);
    return \@cols;
}

sub create_int_table
{
    my $schema = shift;
    my $interim = shift;
    my $columns = shift;

    print("\ncreate table $schema.$interim\n(\n");

    foreach my $column (@$columns)
    {
        if ($$column{name} eq "DATE")
        {
            print("  \"$$column{name}\"");
        }
        else
        {
            print("  $$column{name}");
        }
        
        print("  $$column{data_type}");

        if ($$column{data_type} eq "NUMBER")
        {
            if (!($$column{data_precision} eq "-") && !($$column{data_scale} eq "-"))
            {
                print "($$column{data_precision}, $$column{data_scale})";
            }
        }
        elsif ($$column{data_type} =~ "CHAR")
        {
            print "($$column{data_len})";
        }
        else
        {
        }

        if ($$column{nullable} eq "N")
        {
            print("  NOT NULL");
        }
        print(",\n");
    }

    print(")\n");
}

sub get_table_info
{
    my $user = shift;
    my $pass = shift;
    my $db = shift;
    my $schema = shift;
    my $table = shift;

    `sqlplus $user/$pass@"$db" \@get_tab_indexes.sql $schema $table`;
    `sqlplus $user/$pass@"$db" \@get_tab_attr.sql $schema $table`;
    `sqlplus $user/$pass@"$db" \@get_tab_cons.sql $schema $table`;
    `sqlplus $user/$pass@"$db" \@get_tab_cols.sql $schema $table`;
    `sqlplus $user/$pass@"$db" \@get_tab_ref_cons.sql $schema $table`;
    `sqlplus $user/$pass@"$db" \@get_tab_ddl.sql $schema $table`;
}

sub main
{
    my $user = $ARGV[0];
    my $pass = $ARGV[1];
    my $db = $ARGV[2];
    my $schema = uc($ARGV[3]);
    my $table = uc($ARGV[4]);
    my $tbsp_dat = $ARGV[5];
    my $tbsp_idx = $ARGV[6];
    my $interim = "${table}_NEW";

    get_table_info($user, $pass, $db, $schema, $table);
    build_script($schema, $table, $interim, $tbsp_dat, $tbsp_idx);
}

main

