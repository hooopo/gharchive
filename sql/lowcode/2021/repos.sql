  SELECT /*+ read_from_storage(tiflash[github_events]) */
         jf.name as repo_name, 
         count(*) as stars, 
         any_value(jf.id) as repo_id
    FROM github_events
         JOIN nocode_repos jf ON jf.id = github_events.repo_id
   WHERE type = 'WatchEvent' 
GROUP BY 1
ORDER BY 2 DESC
