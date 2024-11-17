begin
  dbms_network_acl_admin.create_acl (
    acl         => 'utl_http.xml',
            description  => 'permissions to access to *',
    principal   => 'PUBLIC',
    is_grant    => TRUE,
    privilege   => 'connect',
    start_date  => null,
    end_date    => null
  );
  dbms_network_acl_admin.add_privilege (
    acl        => 'utl_http.xml',
    principal  => 'PUBLIC',
    is_grant   => TRUE,
    privilege  => 'resolve',
    start_date => null,
    end_date   => null
  );
  dbms_network_acl_admin.assign_acl (
    acl        => 'utl_http.xml',
    host       => '*',
    lower_port => 25,
    upper_port => 11111
  );
  commit;
end;
/
