create or replace package xxapex_tw_pkg   authid definer AS
procedure refresh_Data;
PROCEDURE initialise_account_details;
PROCEDURE projects;
end xxapex_tw_pkg;

GRANT EXECUTE ON xxapex_tw_pkg TO apex_ebs_extension;

SET define OFF
create or replace package BODY xxapex_tw_pkg     IS
 
g_api_key       VARCHAR2(20);
g_account       VARCHAR2(100);
g_start_date        NUMBER;
 
PROCEDURE initialise_account_details IS
BEGIN
   SELECT api_key, account, start_date
   INTO g_api_key, g_account, g_start_date
   FROM apex_ebs_Extension.xxapex_tw_settings;
END;
 
PROCEDURE get_http_data(p_url IN varchar2) IS
                   
v_request       utl_http.req;
v_response      utl_http.resp;
v_progress      VARCHAR2(2);
v_entire_msg        clob;
v_msg           VARCHAR2(80);
                      
BEGIN
   --request that exceptions are raised for error Status Codes
   Utl_Http.Set_Response_Error_Check ( enable => true );
 
   --allow testing for exceptions like Utl_Http.Http_Server_Error
   Utl_Http.Set_Detailed_Excp_Support ( enable => true );
 
   --send HTTP Request and get response
   v_progress := 'a';
   v_request := utl_http.begin_request(url => p_url, method => 'GET');
    
   v_progress := 'b';
   utl_http.Set_Authentication (r => v_request,
                username => g_api_key,
                    password => 'xx');
                     
   v_progress := 'c';
   v_response := utl_http.get_response(r => v_request);
    
   /*Use for debugging
   DBMS_OUTPUT.PUT_LINE('HTTP response status code: ' || v_response.status_code);
   DBMS_OUTPUT.PUT_LINE('HTTP response reason phrase: ' || v_response.reason_phrase);
   FOR i IN 1..UTL_HTTP.GET_HEADER_COUNT(v_response) LOOP
       UTL_HTTP.GET_HEADER(v_response, i, name, value);
       DBMS_OUTPUT.PUT_LINE(name || ': ' || value);
   END LOOP;*/
   
   --Loop through response and add to clob
   v_entire_msg := null;
   begin
      loop
         utl_http.read_text(r => v_response, data => v_msg);
         v_entire_msg := v_entire_msg || v_msg;
      end loop;
   exception
      when utl_http.end_of_body then
           utl_http.end_response(v_response);
   when others then
      utl_tcp.close_all_connections;
      raise_application_error(-20000,'Get Response: '||sqlerrm);
   end;
 
   delete from apex_ebs_Extension.xxapex_tw_json;
 
   insert into apex_ebs_Extension.xxapex_tw_json(json_clob) values (v_entire_msg);
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,'GET_HTTP: '||v_progress||' '||sqlerrm);  
END;                
 
PROCEDURE refresh_TIME IS
   v_url            varchar2(32000);
   v_count      NUMBER := -99;
   v_page       number := 1;
 
   cursor  c_data is
      select minutes, task_id, person_id, hours, time_date, project_id, id, tasklist_id
      FROM apex_ebs_Extension.xxapex_tw_json,
      json_table(json_clob, '$."time-entries"[*]'
      columns (
      minutes varchar2 path '$.minutes',
      id varchar2 path '$."id"',
      task_id varchar2 path '$."todo-item-id"',
      tasklist_id NUMBER path '$."todo-list-id"',
      person_id varchar2 path '$."person-id"',
      time_date varchar2 path '$."date"',
      project_id NUMBER path '$."project-id"',
      hours varchar2 path '$."hours"'
      )
      ) as jt;
 
BEGIN
   delete from apex_ebs_extension.xxapex_tw_time_entries;
    
   WHILE v_count <> 0 loop
 
      v_count := 0;
 
      --Create JSON REQUEST
      v_url := 'http://'||g_account||'/time_entries.json?i&page='||v_page;
      v_page := v_page + 1;
      get_http_data(v_url);
       
      for v_data in c_data loop
 
         v_count := v_count + 1;
         INSERT INTO apex_ebs_Extension.xxapex_tw_time_entries
            (id,
             minutes,
         task_id,
         person_id,
         hours,
         time_date,
         project_id,
         tasklist_id)
     VALUES
        (v_data.id,
         v_data.minutes,
         v_data.task_id,
         v_data.person_id,
         v_data.hours,
         v_data.time_date,
         v_data.project_id,
         v_data.tasklist_id);
           
      end loop;
   end loop; 
END refresh_TIME;
 
procedure tags is
   v_url            varchar2(32000);
    
   CURSOR c_data IS
      select jt.id, name, colour
      from apex_ebs_Extension.xxapex_tw_json,
      json_table(json_clob, '$.tags[*]'
      columns (
      id varchar2 path '$.id' ,
      name varchar2 path '$."name"',
      colour varchar2 path '$."color"'
      error on error
      )
      ) as jt;
 
begin
    
   delete from apex_ebs_extension.xxapex_tw_tags;
    
   --Create JSON REQUEST
   v_url := 'http://'||g_account||'/tags.json';
   get_http_data(v_url);
    
   FOR v_data IN c_data loop
    
      insert INTO apex_ebs_extension.xxapex_tw_tags
         (id,
         name, 
         colour)
       values
         (v_data.id,
          v_data.name,
          v_data.colour);
   end loop;
       
END tags;
 
--This needs to be called from the "tasks" procedure
procedure closed_tasks is
   v_url            varchar2(32000);
   v_count      NUMBER := -99;
   v_page       number := 1;
 
   v_closed_yn      VARCHAR2(1);
   v_task_id        NUMBER := -99;
 
   cursor  c_data  is
      select jt.id, content, project_id, estimated_minutes, due_date_base, status, todo_list_id, tag_id, priority
      FROM apex_ebs_Extension.xxapex_tw_json,
      json_table(json_clob, '$."tasks"[*]'
      columns (
      id varchar2 path '$.id',
      content varchar2 path '$."content"',
      project_id varchar2 path '$."projectId"',
      estimated_minutes varchar2 path '$."estimated-minutes"',
      due_date_base varchar2 path '$."due-date-base"',
      status varchar2 path '$."status"',
      priority VARCHAR2 path '$."priority"',
      todo_list_id varchar2 path '$."tasklistId"',
      NESTED PATH '$.tags[*]' COLUMNS (
             "tag_id" VARCHAR2(5) PATH '$.id')
      )
      ) as jt order by id;
 
begin
    
   WHILE v_count <> 0 loop
 
      v_count := 0;
 
      --Create JSON REQUEST
      v_url:='http://'||g_account||'/completedtasks.json?includeArchivedProjects=true&page='||v_page||'&pageSize=250&startdate='||g_start_date||'&enddate='||TO_CHAR(SYSDATE+1,'YYYYMMDD');
      v_page := v_page + 1;
      get_http_data(v_url);
      v_closed_yn := 'Y';
          
      FOR v_data in c_data loop
 
         v_count := v_count + 1;
 
         IF v_data.id <> v_task_id THEN
            v_task_id := v_data.id;
            insert into apex_ebs_extension.xxapex_tw_tasks
               (id, 
               name, 
               project_id, 
               estimated_minutes, 
               due_date_base, 
               status, 
               tasklist_id,
               closed_yn,
               priority)
            values
               (v_data.id, 
               v_data.content, 
               v_data.project_id, 
               v_data.estimated_minutes, 
               v_data.due_date_base, 
               'Complete', 
               v_data.todo_list_id,
               v_closed_yn,
               v_data.priority);
         END IF;
             
         IF v_data.tag_id IS NOT NULL THEN
            INSERT INTO apex_ebs_extension.xxapex_tw_task_tags
               (task_id,
               tag_id)
            VALUES
               (v_data.id,
               v_data.tag_id);
         END IF;   
 
      end loop;
   end loop;
 
exception
   when others then
      raise_application_error(-20000,'Errors: '||v_page||' '||sqlerrm);
END closed_tasks;
 
procedure tasks is
   v_url            varchar2(32000);
   v_count      NUMBER := -99;
   v_page       number := 1;
 
   v_closed_yn      VARCHAR2(1);
   v_task_id        NUMBER := -99;
 
   cursor  c_data  is
      select jt.id, content, project_id, estimated_minutes, due_date_base, status, todo_list_id, tag_id, priority
      FROM apex_ebs_Extension.xxapex_tw_json,
      json_table(json_clob, '$."todo-items"[*]'
      columns (
      id varchar2 path '$.id',
      content varchar2 path '$."content"',
      project_id varchar2 path '$."project-id"',
      estimated_minutes varchar2 path '$."estimated-minutes"',
      due_date_base varchar2 path '$."due-date-base"',
      status varchar2 path '$."status"',
      priority VARCHAR2 path '$."priority"',
      todo_list_id varchar2 path '$."todo-list-id"',
      NESTED PATH '$.tags[*]' COLUMNS (
             "tag_id" VARCHAR2(5) PATH '$.id')
      )
      ) as jt order by id;
 
begin
     
    DELETE FROM apex_ebs_extension.xxapex_tw_tasks;
    WHILE v_count <> 0 loop
 
      v_count := 0;
 
      --Create JSON REQUEST
      v_url := 'http://'||g_account||'/tasks.json?includeCompletedTasks=true&getSubTasks=true&includeCompletedSubtasks=true&showDeleted=yes&page='||v_page||'&pageSize=250';
      v_page := v_page + 1;
      get_http_data(v_url);
      v_closed_yn := 'N';
       
      for v_data in c_data loop
 
         v_count := v_count + 1;
 
         IF v_data.id <> v_task_id THEN
            v_task_id := v_data.id;
            insert into apex_ebs_extension.xxapex_tw_tasks
               (id, 
               name, 
               project_id, 
               estimated_minutes, 
               due_date_base, 
               status, 
               tasklist_id,
               closed_yn,
               priority)
            values
               (v_data.id, 
               v_data.content, 
               v_data.project_id, 
               v_data.estimated_minutes, 
               v_data.due_date_base, 
               v_data.status, 
               v_data.todo_list_id,
               v_closed_yn,
               v_data.priority);
         END IF;
             
         IF v_data.tag_id IS NOT NULL THEN
            INSERT INTO apex_ebs_extension.xxapex_tw_task_tags
               (task_id,
               tag_id)
            VALUES
               (v_data.id,
               v_data.tag_id);
         END IF;   
 
      end loop;
   end loop; --task pages
    
   --Now get closed_tasks
   closed_tasks;
END;
 
procedure tasklists is
   v_url            varchar2(32000);
    
   CURSOR c_data IS
      select jt.name, jt.description, id, projectid
      from apex_ebs_Extension.xxapex_tw_json,
      json_table(json_clob, '$.tasklists[*]'
      columns (
      name varchar2 path '$.name' ,
      description varchar2 path '$."description"',
      id varchar2 path '$."id"',
      projectid varchar2 path '$.projectId'
      error on error
      )
      ) as jt;
 
begin
   DELETE FROM apex_ebs_Extension.xxapex_tw_tasklists;
   v_url := 'http://'||g_account||'/tasklists.json';
    
   get_http_data(v_url);
    
   FOR v_data IN c_data loop
    
      insert into apex_ebs_Extension.xxapex_tw_tasklists
         (id,
      projectid,
      name,
      description)
       values
          (v_data.id,
      v_data.projectid,
      v_data.name,
      v_data.description);
   end loop;
       
END tasklists;
 
procedure people is
   v_url            varchar2(32000);
    
   CURSOR c_data IS
      select jt.id, jt.last_name, first_name, companyid
      from apex_ebs_Extension.xxapex_tw_json,
      json_table(json_clob, '$.people[*]'
      columns (
      id varchar2 path '$.id' ,
      last_name varchar2 path '$."last-name"',
      first_name varchar2 path '$."first-name"',
      companyid varchar2 path '$.companyId'
      error on error
      )
      ) as jt;
 
begin
   DELETE from apex_ebs_Extension.xxapex_tw_people;
    
   --Create JSON REQUEST
   v_url := 'http://'||g_account||'/people.json';
    
   get_http_data(v_url);
    
   FOR v_data IN c_data loop
    
      insert into apex_ebs_Extension.xxapex_tw_people
         (last_name,
     id,
     first_name,
     company_id)
       values
         (v_data.last_name,
         v_data.id,
         v_data.first_name,
         v_data.companyid);
   end loop;
       
END people;
 
procedure companies is
   v_url            varchar2(32000);
    
   CURSOR c_data IS
      select jt.id, jt.name
      from apex_ebs_Extension.xxapex_tw_json,
      json_table(json_clob, '$.companies[*]'
      columns (
      name varchar2 path '$."name"' ,
      id varchar2 path '$."id"'
      error on error
      )
      ) as jt;
 
begin
 
   delete from apex_ebs_Extension.xxapex_tw_companies;
   --Create JSON REQUEST
   v_url := 'http://'||g_account||'/companies.json';
 
   get_http_data(v_url);
 
   FOR v_data IN c_data loop
 
      insert into apex_ebs_Extension.xxapex_tw_companies
         (name,
          id)
       values
          (v_data.name,
          v_data.id);
    
   end loop;
end companies;
 
procedure projects is
   v_url            varchar2(32000);
    
   CURSOR c_data IS
      select  name, description, status, created_on, category_name, startdate, id, enddate
      from apex_ebs_Extension.xxapex_tw_json,
      json_table(json_clob, '$.projects[*]'
      columns (
      name varchar2 path '$."name"',
      description varchar2 path '$."description"',
      status varchar2 path '$."status"',
      created_on varchar2 path '$."created-on"',
      category_name varchar2 path '$."category.name"',
      startdate varchar2 path '$."startDate"',
      id varchar2 path '$."id"',
      enddate varchar2 path '$."endDate"'
      error on error
      )
      ) as jt;
 
begin
 
   --Create JSON REQUEST
   v_url := 'http://'||g_account||'/projects.json?status=ALL';
   get_http_data(v_url);
 
   DELETE from apex_ebs_Extension.xxapex_tw_projects;
 
   for v_data IN c_data loop
 
      insert into apex_ebs_Extension.xxapex_tw_projects
         (name,
          description,
          status,
          created_on,
          category_name,
          start_date,
          id,
          end_date)
       values
          (v_data.name,
          v_data.description,
          v_data.status,
          v_data.created_on,
          v_data.category_name,
          v_data.startdate,
          v_data.id,
          v_data.enddate);
   end loop;
end projects;
 
/****************************************************************************************************
* This is the main procedure called to refresh all Teamwork data
*****************************************************************************************************/
PROCEDURE REFRESH_DATA IS
BEGIN
   initialise_account_details;
   companies;
   projects;
   people;
   tasklists;
   tasks;
   --closed_tasks; (this is called from the tasks procedure now)
   tags;
   refresh_TIME;
END;
 
end xxapex_tw_pkg;
/
show ERRORS
