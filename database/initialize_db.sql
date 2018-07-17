CREATE DATABASE IF NOT EXISTS `reporting`
USE `reporting`;

DROP TABLE IF EXISTS `advertisers`;

CREATE TABLE `advertisers` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `dcm_advertiser_id` bigint(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `campaigns`;

CREATE TABLE `campaigns` (
  `id` bigint(11) NOT NULL DEFAULT '0',
  `advertiserId` bigint(11) DEFAULT NULL,
  `campaignName` varchar(255) DEFAULT NULL,
  `startDate` date DEFAULT NULL,
  `endDate` date DEFAULT NULL,
  `active` int(1) DEFAULT '0',
  `moatId` bigint(11) DEFAULT NULL,
  `reportId` bigint(20) DEFAULT NULL,
  `floodlightId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `dcm_ads`;

CREATE TABLE `dcm_ads` (
  `id` bigint(20) NOT NULL,
  `advertiserId` bigint(20) NOT NULL,
  `campaignId` bigint(20) NOT NULL,
  `adName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `dcm_creative`;

CREATE TABLE `dcm_creative` (
  `id` bigint(15) NOT NULL,
  `advertiserId` bigint(15) NOT NULL,
  `creativeName` varchar(255) DEFAULT NULL,
  `creativeLength` float DEFAULT NULL,
  `creativeType` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `dcm_groups`;

CREATE TABLE `dcm_groups` (
  `id` int(11) NOT NULL DEFAULT '0',
  `advertiserId` bigint(15) DEFAULT NULL,
  `campaignId` bigint(15) DEFAULT NULL,
  `placementGroupName` varchar(255) DEFAULT NULL,
  `placementGroupType` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `dcm_measures`;

CREATE TABLE `dcm_measures` (
  `advertiserId` bigint(20) DEFAULT NULL,
  `campaignId` bigint(20) DEFAULT NULL,
  `placementId` bigint(11) DEFAULT NULL,
  `adId` bigint(20) DEFAULT NULL,
  `creativeId` bigint(20) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `impressions` bigint(20) DEFAULT NULL,
  `clicks` bigint(20) DEFAULT NULL,
  `activeViewViewableImpressions` int(11) DEFAULT NULL,
  `activeViewMeasurableImpressions` int(11) DEFAULT NULL,
  `activeViewEligibleImpressions` int(11) DEFAULT NULL,
  `click-throughConversions` int(11) DEFAULT NULL,
  `view-throughConversions` int(11) DEFAULT NULL,
  `totalConversions` int(11) DEFAULT NULL,
  `videoPlays` int(11) DEFAULT NULL,
  `videoFirstQuartileCompletions` int(11) DEFAULT NULL,
  `videoThirdQuartileCompletions` int(11) DEFAULT NULL,
  `videoMidpoints` int(11) DEFAULT NULL,
  `videoCompletions` int(11) DEFAULT NULL,
  `videoViews` int(11) DEFAULT NULL,
  `videoAverageViewTime` double DEFAULT NULL,
  UNIQUE KEY `unique_index` (`campaignId`,`placementId`,`adId`,`creativeId`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `dcm_placements`;

CREATE TABLE `dcm_placements` (
  `id` int(11) NOT NULL DEFAULT '0',
  `advertiserId` bigint(15) DEFAULT NULL,
  `campaignId` bigint(15) DEFAULT NULL,
  `placementGroupId` bigint(15) DEFAULT NULL,
  `placementName` varchar(255) DEFAULT NULL,
  `pricingType` varchar(255) DEFAULT NULL,
  `siteId` bigint(15) DEFAULT NULL,
  `startDate` date DEFAULT NULL,
  `endDate` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `dcm_sites`;

CREATE TABLE `dcm_sites` (
  `id` int(11) DEFAULT NULL,
  `site` varchar(255) DEFAULT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `moat_display`;

CREATE TABLE `moat_display` (
  `level3_id` bigint(20) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `active_in_view_time` double DEFAULT NULL,
  `full_vis_2_sec_continuous_inview` int(11) DEFAULT NULL,
  `groupm_display_imps` bigint(20) DEFAULT NULL,
  `impressions_analyzed` bigint(20) DEFAULT NULL,
  `l_full_visibility_measurable` int(11) DEFAULT NULL,
  `measurable_impressions` bigint(20) DEFAULT NULL,
  UNIQUE KEY `unique` (`date`,`level3_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `moat_video`;

CREATE TABLE `moat_video` (
  `level3_id` bigint(20) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `2_sec_video_in_view_impressions` int(11) DEFAULT NULL,
  `2_sec_video_in_view_percent` double DEFAULT NULL,
  `ad_vis_and_aud_on_complete_percent` double DEFAULT NULL,
  `groupm_video_ots_completion` bigint(20) DEFAULT NULL,
  `human_and_groupm_video_payable_sum` bigint(20) DEFAULT NULL,
  `impressions_analyzed` bigint(20) DEFAULT NULL,
  `l_full_visibility_measurable` bigint(20) DEFAULT NULL,
  `measurable_impressions` bigint(20) DEFAULT NULL,
  `player_audible_full_vis_half_time_sum` bigint(20) DEFAULT NULL,
  `player_vis_and_aud_on_complete_sum` bigint(20) DEFAULT NULL,
  `valid_and_groupm_video_payable_sum` bigint(20) DEFAULT NULL,
  `viewable_gm_video_15cap_sum` bigint(20) DEFAULT NULL,
  UNIQUE KEY `unique` (`date`,`level3_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;