CREATE TEMP TABLE archive AS SELECT 
  id,
  type,
  created_at,
  repo.id as repo_id,
    CASE repo.name
      WHEN '/' THEN json_value(payload, '$.repo')
      WHEN null THEN json_value(payload, '$.repo')
      ELSE repo.name
    END
  as repo_name,
  actor.id as actor_id,
  actor.login as actor_login,
  json_value(payload, '$.pull_request.base.repo.language') as language,
  json_value(payload, '$.pull_request.additions') as additions,
  json_value(payload, '$.pull_request.deletions') as deletions,
  json_value(payload, '$.action') as action,
    CASE 
      WHEN json_value(payload, '$.pull_request.number') is not null THEN json_value(payload, '$.pull_request.number')
      WHEN json_value(payload, '$.issue.number') is not null THEN json_value(payload, '$.issue.number')
      ELSE json_value(payload, '$.number')
    END 
  as number,
  json_value(payload, '$.commit.commit_id') as commit_id,
  json_value(payload, '$.comment.id') as comment_id,
  org.login as org_login,
  org.id as org_id,
    CASE 
      WHEN json_value(payload, '$.pull_request.state') is not null THEN json_value(payload, '$.pull_request.state')
      WHEN json_value(payload, '$.issue.state') is not null THEN json_value(payload, '$.issue.state')
      ELSE null
    END 
  as state,
    CASE 
      WHEN json_value(payload, '$.pull_request.closed_at') is not null THEN json_value(payload, '$.pull_request.closed_at')
      WHEN json_value(payload, '$.issue.closed_at') is not null THEN json_value(payload, '$.issue.closed_at')
      ELSE null
    END 
  as closed_at,
    CASE 
      WHEN json_value(payload, '$.pull_request.comments') is not null THEN json_value(payload, '$.pull_request.losed_at')
      WHEN json_value(payload, '$.issue.comments') is not null THEN json_value(payload, '$.issue.comments')
      ELSE null
    END 
  as comments,
    CASE 
      WHEN json_value(payload, '$.pull_request.milestone.title') is not null THEN json_value(payload, '$.pull_request.milestone.title')
      WHEN json_value(payload, '$.issue.milestone.title') is not null THEN json_value(payload, '$.issue.milestone.title')
      ELSE null
    END
  as milestone,
  json_value(payload, '$.pull_request.merged_at') as pr_merged_at,
  json_value(payload, '$.pull_request.changed_files') as pr_changed_files,
  json_value(payload, '$.pull_request.review_comments') as pr_review_comments,
    CASE 
      WHEN json_value(payload, '$.pull_request.id') is not null THEN json_value(payload, '$.pull_request.id')
      WHEN json_value(payload, '$.issue.id') is not null THEN json_value(payload, '$.issue.id')
      ELSE null
    END 
  as pr_or_issue_id,
  EXTRACT(day FROM created_at) as event_day,
  EXTRACT(month FROM created_at) as event_month,
  EXTRACT(year FROM created_at) as event_year

FROM `githubarchive.day.20200522`;

EXPORT DATA OPTIONS(
  uri='gs://gharchive.live/day1/*.csv',
  format='CSV',
  overwrite=true,
  header=true,
  field_delimiter=',') AS
  SELECT * FROM archive