
\set ECHO off

set log_error_verbosity = 'terse';
set client_min_messages = 'fatal';
create language plpgsql;
set client_min_messages = 'warning';

drop schema pgq_ext cascade;
\i sql/old_ext.sql
\i structure/upgrade.sql
\set ECHO all

--
-- test batch tracking
--
select pgq_ext.is_batch_done('c', 1);
select pgq_ext.set_batch_done('c', 1);
select pgq_ext.is_batch_done('c', 1);
select pgq_ext.set_batch_done('c', 1);
select pgq_ext.is_batch_done('c', 2);
select pgq_ext.set_batch_done('c', 2);

--
-- test event tracking
--
select pgq_ext.is_batch_done('c', 3);
select pgq_ext.is_event_done('c', 3, 101);
select pgq_ext.set_event_done('c', 3, 101);
select pgq_ext.is_event_done('c', 3, 101);
select pgq_ext.set_event_done('c', 3, 101);
select pgq_ext.set_batch_done('c', 3);
select * from pgq_ext.completed_event order by 1,2;

--
-- test tick tracking
--
select pgq_ext.get_last_tick('c');
select pgq_ext.set_last_tick('c', 1);
select pgq_ext.get_last_tick('c');
select pgq_ext.set_last_tick('c', 2);
select pgq_ext.get_last_tick('c');
select pgq_ext.set_last_tick('c', NULL);
select pgq_ext.get_last_tick('c');

