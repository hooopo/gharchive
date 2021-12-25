
DROP TABLE IF EXISTS `cn_orgs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cn_orgs` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) /*T![clustered_index] NONCLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;



/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `cn_repos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cn_repos` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) /*T![clustered_index] NONCLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;



/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `db_repos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `db_repos` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) /*T![clustered_index] NONCLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;



/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `github_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `github_events` (
  `id` bigint(20) DEFAULT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `repo_id` bigint(20) DEFAULT NULL,
  `repo_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `actor_id` bigint(20) DEFAULT NULL,
  `actor_login` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `actor_location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `language` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `additions` bigint(20) DEFAULT NULL,
  `deletions` bigint(20) DEFAULT NULL,
  `action` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `number` int(11) DEFAULT NULL,
  `commit_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comment_id` bigint(20) DEFAULT NULL,
  `org_login` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `org_id` bigint(20) DEFAULT NULL,
  `state` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `closed_at` datetime DEFAULT NULL,
  `comments` int(11) DEFAULT NULL,
  `pr_merged_at` datetime DEFAULT NULL,
  `pr_merged` tinyint(1) DEFAULT NULL,
  `pr_changed_files` int(11) DEFAULT NULL,
  `pr_review_comments` int(11) DEFAULT NULL,
  `pr_or_issue_id` bigint(20) DEFAULT NULL,
  `event_day` date DEFAULT NULL,
  `event_month` date DEFAULT NULL,
  `author_association` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `event_year` int(11) DEFAULT NULL,
  `push_size` int(11) DEFAULT NULL,
  `push_distinct_size` int(11) DEFAULT NULL,
  KEY `index_github_events_on_id` (`id`),
  KEY `index_github_events_on_action` (`action`),
  KEY `index_github_events_on_actor_id` (`actor_id`),
  KEY `index_github_events_on_actor_login` (`actor_login`),
  KEY `index_github_events_on_additions` (`additions`),
  KEY `index_github_events_on_closed_at` (`closed_at`),
  KEY `index_github_events_on_comment_id` (`comment_id`),
  KEY `index_github_events_on_comments` (`comments`),
  KEY `index_github_events_on_commit_id` (`commit_id`),
  KEY `index_github_events_on_created_at` (`created_at`),
  KEY `index_github_events_on_deletions` (`deletions`),
  KEY `index_github_events_on_event_day` (`event_day`),
  KEY `index_github_events_on_event_month` (`event_month`),
  KEY `index_github_events_on_event_year` (`event_year`),
  KEY `index_github_events_on_language` (`language`),
  KEY `index_github_events_on_org_id` (`org_id`),
  KEY `index_github_events_on_org_login` (`org_login`),
  KEY `index_github_events_on_pr_changed_files` (`pr_changed_files`),
  KEY `index_github_events_on_pr_merged_at` (`pr_merged_at`),
  KEY `index_github_events_on_pr_or_issue_id` (`pr_or_issue_id`),
  KEY `index_github_events_on_pr_review_comments` (`pr_review_comments`),
  KEY `index_github_events_on_repo_id` (`repo_id`),
  KEY `index_github_events_on_repo_name` (`repo_name`),
  KEY `index_github_events_on_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



