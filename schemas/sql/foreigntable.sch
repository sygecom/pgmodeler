# SQL definition for foreign tables
# CAUTION: Do not modify this file unless you know what you are doing.
#          Code generation can be broken if incorrect changes are made.
[-- object: ] {name} [ | type: ] {sql-object} [ --] $br

[-- ] {drop}

%if {prepended-sql} %then
    {prepended-sql}
    $br [-- ddl-end --] $br $br
%end

[CREATE FOREIGN TABLE ] {name} 

%if ({pgsql-ver} >=f "10.0") %and {partitioned-table} %then [ PARTITION OF ] {partitioned-table} $sp %end

%if %not {partitioned-table} %or ({pgsql-ver} <f "10.0")  %then 

[ (] $br

%if %not {gen-alter-cmds} %then
    %if {columns} %then 
        {columns} 
        
        %if %not {constr-sql-disabled} %and {constraints} %then [,] $br %end
    %end
    
    %if {inh-columns} %then 
        $br {inh-columns} 
    %end

    %if {constraints} %then
        {constraints}
    %end
  %end
$br )

%else 
    %if {partitioned-table} %and {constraints} %then
        [ (] $br {constraints} [)] $br
    %end
%end

%if ({pgsql-ver} >=f "10.0") %and {partitioned-table} %then 
    %if {partition-bound-expr} %then
        $br [FOR VALUES ] {partition-bound-expr}
    %else
        DEFAULT
    %end
%end

%if ({pgsql-ver} >=f "10.0") %and {partitioning} %then $br [PARTITION BY ] {partitioning} [ (] {partitionkey} [)] %end
%if {ancestor-table} %then [ INHERITS(] {ancestor-table} [)] %end
%if {server} %then $br [SERVER ] {server} %end
%if {options} %then $br [OPTIONS (] {options} [)] %end
%if {oids} %then [WITH ( OIDS = TRUE )] %end

; $br

[-- ddl-end --] $br

%if {gen-alter-cmds} %then
  %if {columns} %then $br {columns} %end
  %if {constraints} %then $br {constraints} %end
%end

%if {comment} %then {comment} %end
%if {cols-comment} %then {cols-comment} %end
%if {owner} %then {owner} %end

%if {appended-sql} %then
 {appended-sql}
 $br [-- ddl-end --] $br
%end

%if {initial-data} %then
 $br {initial-data} $br
%end

$br