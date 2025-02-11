select constraint_name from information_schema.constraint_column_usage where
table_name = 'user_access' and column_name = 'access_id'
and constraint_name <> 'unique_access_user';

alter table user_access drop CONSTRAINT "CONSTRAINT_NAME";
