
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `ar_internal_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ar_internal_metadata` (
  `key` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`key`) /*T![clustered_index] NONCLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
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
DROP TABLE IF EXISTS `gh`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gh` (
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
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `import_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `import_logs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) NOT NULL,
  `local_file` varchar(255) DEFAULT NULL,
  `start_download_at` datetime DEFAULT NULL,
  `end_download_at` datetime DEFAULT NULL,
  `start_import_at` datetime DEFAULT NULL,
  `end_import_at` datetime DEFAULT NULL,
  `start_batch_at` datetime DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `index_import_logs_on_filename` (`filename`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin AUTO_INCREMENT=180001;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `nocode_repos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nocode_repos` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) /*T![clustered_index] NONCLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  PRIMARY KEY (`version`) /*T![clustered_index] NONCLUSTERED */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `company` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USR',
  `fake` tinyint(1) NOT NULL DEFAULT '0',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  `long` decimal(11,8) DEFAULT NULL,
  `lat` decimal(10,8) DEFAULT NULL,
  `country_code` char(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) /*T![clustered_index] CLUSTERED */,
  KEY `index_login_on_users` (`login`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=68024323;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

INSERT INTO `schema_migrations` (version) VALUES
('20211118190004'),
('20211205174309'),
('20211205190931'),
('20211206155721'),
('20211208112931'),
('20211214161151'),
('20220110101625');


