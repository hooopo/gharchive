SELECT /*+ read_from_storage(tiflash[github_events]) */
  db_repos.name AS repo_name,
  COUNT(*) AS num
FROM github_events 
JOIN db_repos ON db_repos.id = github_events.repo_id
WHERE type = 'WatchEvent' AND event_year = 2021
GROUP BY db_repos.name
ORDER BY 2 desc
LIMIT 10