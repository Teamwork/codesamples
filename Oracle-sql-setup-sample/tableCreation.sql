create table apex_ebs_Extension.xxapex_tw_json(
json_clob  clob,
   constraint json_clob_chk check (json_clob is json));
    
create table apex_ebs_extension.xxapex_tw_time_entries
(id number,
minutes number,
task_id number,
person_id number,
hours number,
time_date  varchar2(30),
project_id number,
tasklist_id number);
 
create table apex_ebs_extension.xxapex_tw_tasks
(id number,
name varchar2(2000),
project_id number,
            estimated_minutes number,
            due_date_base number,
            status varchar2(30),
            tasklist_id number,
            priority varchar2(10),
            closed_yn varchar2(1));
 
create table apex_ebs_extension.xxapex_tw_tags
(id number,
name varchar2(100),
colour varchar2(10));
 
create table apex_ebs_extension.xxapex_tw_task_tags
(task_id number,
tag_id number);
 
create table apex_ebs_extension.xxapex_tw_tasklists
(id number,
projectid number,
name    varchar2(200),
description varchar2(2000));
 
create table apex_ebs_extension.xxapex_tw_projects
(name varchar2(200),
description varchar2(4000),
status varchar2(10),
created_on varchar2(20),
category_name varchar2(100),
start_date varchar2(20),
id number,
end_date varchar2(20));
 
create table apex_ebs_extension.xxapex_tw_companies
(name varchar2(200),
id    number);
CREATE TABLE "APEX_EBS_EXTENSION"."XXAPEX_TW_PEOPLE"
   (    "LAST_NAME" VARCHAR2(200 BYTE),
    "ID" NUMBER,
    "FIRST_NAME" VARCHAR2(200 BYTE),
    "COMPANY_ID" NUMBER
   )  ;