





WITH base AS (
  
    SELECT
      
  
  

  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  

  `t`.`Video Completes` AS video_completes,
  `t`.`Engagements` AS engagements,
  `t`.`Video Start` AS video_start,
  `t`.`Age` AS age,
  `t`.`Gender` AS gender,
  `t`.`DMA Name` AS dma_name,
  `t`.`Audience Name` AS audience_name,
  `t`.`Audience` AS audience,
  `t`.`Creative URL` AS creative_url,
  `t`.`Date` AS date,
  `t`.`Advertiser ID` AS advertiser_id,
  `t`.`Campaign Group ID` AS campaign_group_id,
  `t`.`Conversions` AS conversions,
  `t`.`Impressions` AS impressions,
  `t`.`Device` AS device,
  `t`.`congressional_district` AS congressional_district,
  `t`.`s_conv_from` AS s_conv_from,
  `t`.`Video Completion Rate` AS video_completion_rate,
  `t`.`location_id` AS location_id,
  `t`.`Spend` AS spend,
  `t`.`Domain` AS domain,
  `t`.`Engagement Rate` AS engagement_rate,
  `t`.`NativeAd ID` AS nativead_id,
  `t`.`Supply Source` AS supply_source,
  `t`.`conv_from` AS conv_from,
  `t`.`network_id` AS network_id,
  `t`.`Clicks` AS clicks,
  `t`.`Channels` AS channels,
  `t`.`Audio Completion Rate` AS audio_completion_rate,
  `t`.`City` AS city,
  `t`.`Secondary Conversions` AS secondary_conversions,
  `t`.`Campaign Name` AS campaign_name,
  `t`.`Creative ID` AS creative_id,
  `t`.`Region` AS region,
  `t`.`Campaign Group Name` AS campaign_group_name,
  `t`.`DMA` AS dma,
  `t`.`Country` AS country,
  `t`.`Audio Completes` AS audio_completes,
  `t`.`Audience Type` AS audience_type,
  `t`.`Advertiser Name` AS advertiser_name,
  `t`.`Creative Name` AS creative_name,
  `t`.`Audio Start` AS audio_start,
  `t`.`Campaign ID` AS campaign_id
,
      'BlueVine' AS source_table
    FROM secure-electron-279822.PS_Ads_Data.StackAdapt_BlueVine_table_bigquery AS t
    
      UNION ALL
    
  
    SELECT
      
  
  

  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  

  `t`.`Video Completes` AS video_completes,
  `t`.`Engagements` AS engagements,
  `t`.`Video Start` AS video_start,
  `t`.`Age` AS age,
  `t`.`Gender` AS gender,
  `t`.`DMA Name` AS dma_name,
  `t`.`Audience Name` AS audience_name,
  `t`.`Audience` AS audience,
  `t`.`Creative URL` AS creative_url,
  `t`.`Date` AS date,
  `t`.`Advertiser ID` AS advertiser_id,
  `t`.`Campaign Group ID` AS campaign_group_id,
  `t`.`Conversions` AS conversions,
  `t`.`Impressions` AS impressions,
  `t`.`Device` AS device,
  `t`.`congressional_district` AS congressional_district,
  `t`.`s_conv_from` AS s_conv_from,
  `t`.`Video Completion Rate` AS video_completion_rate,
  `t`.`location_id` AS location_id,
  `t`.`Spend` AS spend,
  `t`.`Domain` AS domain,
  `t`.`Engagement Rate` AS engagement_rate,
  `t`.`NativeAd ID` AS nativead_id,
  `t`.`Supply Source` AS supply_source,
  `t`.`conv_from` AS conv_from,
  `t`.`network_id` AS network_id,
  `t`.`Clicks` AS clicks,
  `t`.`Channels` AS channels,
  `t`.`Audio Completion Rate` AS audio_completion_rate,
  `t`.`City` AS city,
  `t`.`Secondary Conversions` AS secondary_conversions,
  `t`.`Campaign Name` AS campaign_name,
  `t`.`Creative ID` AS creative_id,
  `t`.`Region` AS region,
  `t`.`Campaign Group Name` AS campaign_group_name,
  `t`.`DMA` AS dma,
  `t`.`Country` AS country,
  `t`.`Audio Completes` AS audio_completes,
  `t`.`Audience Type` AS audience_type,
  `t`.`Advertiser Name` AS advertiser_name,
  `t`.`Creative Name` AS creative_name,
  `t`.`Audio Start` AS audio_start,
  `t`.`Campaign ID` AS campaign_id
,
      'Cengage' AS source_table
    FROM secure-electron-279822.PS_Ads_Data.StackAdapt_Cengage_table_bigquery AS t
    
      UNION ALL
    
  
    SELECT
      
  
  

  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  

  `t`.`Video Completes` AS video_completes,
  `t`.`Engagements` AS engagements,
  `t`.`Video Start` AS video_start,
  `t`.`Age` AS age,
  `t`.`Gender` AS gender,
  `t`.`DMA Name` AS dma_name,
  `t`.`Audience Name` AS audience_name,
  `t`.`Audience` AS audience,
  `t`.`Creative URL` AS creative_url,
  `t`.`Date` AS date,
  `t`.`Advertiser ID` AS advertiser_id,
  `t`.`Campaign Group ID` AS campaign_group_id,
  `t`.`Conversions` AS conversions,
  `t`.`Impressions` AS impressions,
  `t`.`Device` AS device,
  `t`.`congressional_district` AS congressional_district,
  `t`.`s_conv_from` AS s_conv_from,
  `t`.`Video Completion Rate` AS video_completion_rate,
  `t`.`location_id` AS location_id,
  `t`.`Spend` AS spend,
  `t`.`Domain` AS domain,
  `t`.`Engagement Rate` AS engagement_rate,
  `t`.`NativeAd ID` AS nativead_id,
  `t`.`Supply Source` AS supply_source,
  `t`.`conv_from` AS conv_from,
  `t`.`network_id` AS network_id,
  `t`.`Clicks` AS clicks,
  `t`.`Channels` AS channels,
  `t`.`Audio Completion Rate` AS audio_completion_rate,
  `t`.`City` AS city,
  `t`.`Secondary Conversions` AS secondary_conversions,
  `t`.`Campaign Name` AS campaign_name,
  `t`.`Creative ID` AS creative_id,
  `t`.`Region` AS region,
  `t`.`Campaign Group Name` AS campaign_group_name,
  `t`.`DMA` AS dma,
  `t`.`Country` AS country,
  `t`.`Audio Completes` AS audio_completes,
  `t`.`Audience Type` AS audience_type,
  `t`.`Advertiser Name` AS advertiser_name,
  `t`.`Creative Name` AS creative_name,
  `t`.`Audio Start` AS audio_start,
  `t`.`Campaign ID` AS campaign_id
,
      'HoneyBook' AS source_table
    FROM secure-electron-279822.PS_Ads_Data.StackAdapt_HoneyBook_table_bigquery AS t
    
      UNION ALL
    
  
    SELECT
      
  
  

  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  

  `t`.`Video Completes` AS video_completes,
  `t`.`Engagements` AS engagements,
  `t`.`Video Start` AS video_start,
  `t`.`Age` AS age,
  `t`.`Gender` AS gender,
  `t`.`DMA Name` AS dma_name,
  `t`.`Audience Name` AS audience_name,
  `t`.`Audience` AS audience,
  `t`.`Creative URL` AS creative_url,
  `t`.`Date` AS date,
  `t`.`Advertiser ID` AS advertiser_id,
  `t`.`Campaign Group ID` AS campaign_group_id,
  `t`.`Conversions` AS conversions,
  `t`.`Impressions` AS impressions,
  `t`.`Device` AS device,
  `t`.`congressional_district` AS congressional_district,
  `t`.`s_conv_from` AS s_conv_from,
  `t`.`Video Completion Rate` AS video_completion_rate,
  `t`.`location_id` AS location_id,
  `t`.`Spend` AS spend,
  `t`.`Domain` AS domain,
  `t`.`Engagement Rate` AS engagement_rate,
  `t`.`NativeAd ID` AS nativead_id,
  `t`.`Supply Source` AS supply_source,
  `t`.`conv_from` AS conv_from,
  `t`.`network_id` AS network_id,
  `t`.`Clicks` AS clicks,
  `t`.`Channels` AS channels,
  `t`.`Audio Completion Rate` AS audio_completion_rate,
  `t`.`City` AS city,
  `t`.`Secondary Conversions` AS secondary_conversions,
  `t`.`Campaign Name` AS campaign_name,
  `t`.`Creative ID` AS creative_id,
  `t`.`Region` AS region,
  `t`.`Campaign Group Name` AS campaign_group_name,
  `t`.`DMA` AS dma,
  `t`.`Country` AS country,
  `t`.`Audio Completes` AS audio_completes,
  `t`.`Audience Type` AS audience_type,
  `t`.`Advertiser Name` AS advertiser_name,
  `t`.`Creative Name` AS creative_name,
  `t`.`Audio Start` AS audio_start,
  `t`.`Campaign ID` AS campaign_id
,
      'ObamaFoundation' AS source_table
    FROM secure-electron-279822.PS_Ads_Data.StackAdapt_ObamaFoundation_table_bigquery AS t
    
      UNION ALL
    
  
    SELECT
      
  
  

  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  

  `t`.`Video Completes` AS video_completes,
  `t`.`Engagements` AS engagements,
  `t`.`Video Start` AS video_start,
  `t`.`Age` AS age,
  `t`.`Gender` AS gender,
  `t`.`DMA Name` AS dma_name,
  `t`.`Audience Name` AS audience_name,
  `t`.`Audience` AS audience,
  `t`.`Creative URL` AS creative_url,
  `t`.`Date` AS date,
  `t`.`Advertiser ID` AS advertiser_id,
  `t`.`Campaign Group ID` AS campaign_group_id,
  `t`.`Conversions` AS conversions,
  `t`.`Impressions` AS impressions,
  `t`.`Device` AS device,
  `t`.`congressional_district` AS congressional_district,
  `t`.`s_conv_from` AS s_conv_from,
  `t`.`Video Completion Rate` AS video_completion_rate,
  `t`.`location_id` AS location_id,
  `t`.`Spend` AS spend,
  `t`.`Domain` AS domain,
  `t`.`Engagement Rate` AS engagement_rate,
  `t`.`NativeAd ID` AS nativead_id,
  `t`.`Supply Source` AS supply_source,
  `t`.`conv_from` AS conv_from,
  `t`.`network_id` AS network_id,
  `t`.`Clicks` AS clicks,
  `t`.`Channels` AS channels,
  `t`.`Audio Completion Rate` AS audio_completion_rate,
  `t`.`City` AS city,
  `t`.`Secondary Conversions` AS secondary_conversions,
  `t`.`Campaign Name` AS campaign_name,
  `t`.`Creative ID` AS creative_id,
  `t`.`Region` AS region,
  `t`.`Campaign Group Name` AS campaign_group_name,
  `t`.`DMA` AS dma,
  `t`.`Country` AS country,
  `t`.`Audio Completes` AS audio_completes,
  `t`.`Audience Type` AS audience_type,
  `t`.`Advertiser Name` AS advertiser_name,
  `t`.`Creative Name` AS creative_name,
  `t`.`Audio Start` AS audio_start,
  `t`.`Campaign ID` AS campaign_id
,
      'OmniaJamesWhitneyCo' AS source_table
    FROM secure-electron-279822.PS_Ads_Data.StackAdapt_OmniaJamesWhitneyCo_table_bigquery AS t
    
      UNION ALL
    
  
    SELECT
      
  
  

  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  
    
  

  `t`.`Video Completes` AS video_completes,
  `t`.`Engagements` AS engagements,
  `t`.`Video Start` AS video_start,
  `t`.`Age` AS age,
  `t`.`Gender` AS gender,
  `t`.`DMA Name` AS dma_name,
  `t`.`Audience Name` AS audience_name,
  `t`.`Audience` AS audience,
  `t`.`Creative URL` AS creative_url,
  `t`.`Date` AS date,
  `t`.`Advertiser ID` AS advertiser_id,
  `t`.`Campaign Group ID` AS campaign_group_id,
  `t`.`Conversions` AS conversions,
  `t`.`Impressions` AS impressions,
  `t`.`Device` AS device,
  `t`.`congressional_district` AS congressional_district,
  `t`.`s_conv_from` AS s_conv_from,
  `t`.`Video Completion Rate` AS video_completion_rate,
  `t`.`location_id` AS location_id,
  `t`.`Spend` AS spend,
  `t`.`Domain` AS domain,
  `t`.`Engagement Rate` AS engagement_rate,
  `t`.`NativeAd ID` AS nativead_id,
  `t`.`Supply Source` AS supply_source,
  `t`.`conv_from` AS conv_from,
  `t`.`network_id` AS network_id,
  `t`.`Clicks` AS clicks,
  `t`.`Channels` AS channels,
  `t`.`Audio Completion Rate` AS audio_completion_rate,
  `t`.`City` AS city,
  `t`.`Secondary Conversions` AS secondary_conversions,
  `t`.`Campaign Name` AS campaign_name,
  `t`.`Creative ID` AS creative_id,
  `t`.`Region` AS region,
  `t`.`Campaign Group Name` AS campaign_group_name,
  `t`.`DMA` AS dma,
  `t`.`Country` AS country,
  `t`.`Audio Completes` AS audio_completes,
  `t`.`Audience Type` AS audience_type,
  `t`.`Advertiser Name` AS advertiser_name,
  `t`.`Creative Name` AS creative_name,
  `t`.`Audio Start` AS audio_start,
  `t`.`Campaign ID` AS campaign_id
,
      'TheNatureConservancy' AS source_table
    FROM secure-electron-279822.PS_Ads_Data.StackAdapt_TheNatureConservancy_table_bigquery AS t
    
  
),

mapping AS (
  SELECT *
  FROM `ps-silver-gold.mapping.mapping`
  WHERE ad_platform = 'stackadapt'
)

SELECT 
  base.*,
  mapping.client_name,
  mapping.client_id,
  mapping.ad_platform,
  mapping.sub_client_name
FROM base
LEFT JOIN mapping
  ON CAST(base.advertiser_id AS STRING) = CAST(mapping.account_id AS STRING)

