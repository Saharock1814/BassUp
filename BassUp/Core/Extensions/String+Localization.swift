//
//  String+Localization.swift
//  BassUp
//
//  Copyright © 2024 BassUp. All rights reserved.
//

import Foundation

extension String {
    
    /// Returns a localized version of the string
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// Returns a localized version of the string with format arguments
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
    
    /// Returns a localized version of the string with a single format argument
    func localized(with argument: CVarArg) -> String {
        return String(format: self.localized, argument)
    }
    
    /// Returns a localized version of the string with multiple format arguments
    func localized(with arguments: [CVarArg]) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}

// MARK: - Localization Keys

extension String {
    
    // MARK: - App General
    static let appName = "app_name"
    static let appTagline = "app_tagline"
    
    // MARK: - Tab Navigation
    static let tabLearn = "tab_learn"
    static let tabPractice = "tab_practice"
    static let tabTheory = "tab_theory"
    static let tabProgress = "tab_progress"
    static let tabProfile = "tab_profile"
    
    // MARK: - Authentication
    static let authWelcomeBack = "auth_welcome_back"
    static let authCreateAccount = "auth_create_account"
    static let authContinueBassJourney = "auth_continue_bass_journey"
    static let authDisplayName = "auth_display_name"
    static let authDisplayNamePlaceholder = "auth_display_name_placeholder"
    static let authEmail = "auth_email"
    static let authEmailPlaceholder = "auth_email_placeholder"
    static let authPassword = "auth_password"
    static let authPasswordPlaceholder = "auth_password_placeholder"
    static let authSignIn = "auth_sign_in"
    static let authCreateAccountButton = "auth_create_account_button"
    static let authAlreadyHaveAccount = "auth_already_have_account"
    static let authDontHaveAccount = "auth_dont_have_account"
    static let authForgotPassword = "auth_forgot_password"
    static let authOrContinueWith = "auth_or_continue_with"
    static let authResetPassword = "auth_reset_password"
    static let authResetPasswordDescription = "auth_reset_password_description"
    static let authSendResetLink = "auth_send_reset_link"
    static let authCancel = "auth_cancel"
    
    // MARK: - Learn View
    static let learnWelcomeBack = "learn_welcome_back"
    static let learnContinueJourney = "learn_continue_journey"
    static let learnCurrentLesson = "learn_current_lesson"
    static let learnContinue = "learn_continue"
    static let learnRecommended = "learn_recommended"
    static let learnStart = "learn_start"
    static let learnCategories = "learn_categories"
    static let learnRecentLessons = "learn_recent_lessons"
    static let learnAllLessons = "learn_all_lessons"
    static let learnFilter = "learn_filter"
    static let learnXpToNextLevel = "learn_xp_to_next_level"
    
    // MARK: - Practice View
    static let practicePracticeTime = "practice_practice_time"
    static let practiceImproveSkills = "practice_improve_skills"
    static let practiceTotalPractice = "practice_total_practice"
    static let practiceDayStreak = "practice_day_streak"
    static let practiceQuickStart = "practice_quick_start"
    static let practiceStartPractice = "practice_start_practice"
    static let practiceMetronome = "practice_metronome"
    static let practiceCurrentSession = "practice_current_session"
    static let practiceEndSession = "practice_end_session"
    static let practiceDuration = "practice_duration"
    static let practiceAccuracy = "practice_accuracy"
    static let practicePracticeTools = "practice_practice_tools"
    static let practiceKeepTime = "practice_keep_time"
    static let practiceTuneBass = "practice_tune_bass"
    static let practiceRecordYourself = "practice_record_yourself"
    static let practicePlayAlong = "practice_play_along"
    static let practiceRecommended = "practice_recommended"
    static let practiceAllExercises = "practice_all_exercises"
    static let practiceRecentPractice = "practice_recent_practice"
    static let practiceNoRecentActivity = "practice_no_recent_activity"
    
    // MARK: - Theory View
    static let theoryMusicTheory = "theory_music_theory"
    static let theoryMasterFundamentals = "theory_master_fundamentals"
    static let theoryCompleted = "theory_completed"
    static let theoryComplete = "theory_complete"
    static let theoryCategories = "theory_categories"
    static let theoryFeatured = "theory_featured"
    static let theoryViewAll = "theory_view_all"
    static let theoryAllTopics = "theory_all_topics"
    static let theoryTopics = "theory_topics"
    static let theoryExamples = "theory_examples"
    static let theoryExercises = "theory_exercises"
    static let theoryLearn = "theory_learn"
    
    // MARK: - Progress View
    static let progressYourProgress = "progress_your_progress"
    static let progressTrackJourney = "progress_track_journey"
    static let progressOverview = "progress_overview"
    static let progressTotalPractice = "progress_total_practice"
    static let progressAccuracy = "progress_accuracy"
    static let progressStreak = "progress_streak"
    static let progressLessons = "progress_lessons"
    static let progressPracticeTime = "progress_practice_time"
    static let progressAchievements = "progress_achievements"
    static let progressUnlocked = "progress_unlocked"
    static let progressNoAchievements = "progress_no_achievements"
    static let progressCompleteLessonsMessage = "progress_complete_lessons_message"
    static let progressRecentActivity = "progress_recent_activity"
    static let progressNoRecentActivity = "progress_no_recent_activity"
    static let progressGoals = "progress_goals"
    static let progressDailyPractice = "progress_daily_practice"
    static let progressPractice30Min = "progress_practice_30_min"
    static let progressWeeklyPractice = "progress_weekly_practice"
    static let progressPractice35Hours = "progress_practice_3_5_hours"
    static let progressLessonCompletion = "progress_lesson_completion"
    static let progressComplete5Lessons = "progress_complete_5_lessons"
    
    // MARK: - Profile View
    static let profileProfile = "profile_profile"
    static let profileBassPlayer = "profile_bass_player"
    static let profilePremiumMember = "profile_premium_member"
    static let profileEditProfile = "profile_edit_profile"
    static let profileQuickStats = "profile_quick_stats"
    static let profileMemberSince = "profile_member_since"
    static let profileLastLogin = "profile_last_login"
    static let profileAccount = "profile_account"
    static let profilePremiumSubscription = "profile_premium_subscription"
    static let profileActive = "profile_active"
    static let profileUpgradeFeatures = "profile_upgrade_features"
    static let profileChangePassword = "profile_change_password"
    static let profileUpdatePassword = "profile_update_password"
    static let profilePrivacySettings = "profile_privacy_settings"
    static let profileManagePrivacy = "profile_manage_privacy"
    static let profileExportData = "profile_export_data"
    static let profileDownloadData = "profile_download_data"
    static let profileAppSettings = "profile_app_settings"
    static let profileSettings = "profile_settings"
    static let profileCustomizeExperience = "profile_customize_experience"
    static let profileNotifications = "profile_notifications"
    static let profilePracticeReminders = "profile_practice_reminders"
    static let profileSoundEffects = "profile_sound_effects"
    static let profileSupportInfo = "profile_support_info"
    static let profileHelpSupport = "profile_help_support"
    static let profileGetHelp = "profile_get_help"
    static let profileFeedback = "profile_feedback"
    static let profileShareThoughts = "profile_share_thoughts"
    static let profileRateApp = "profile_rate_app"
    static let profileRateAppStore = "profile_rate_app_store"
    static let profileAbout = "profile_about"
    static let profileAppVersionInfo = "profile_app_version_info"
    static let profileTermsService = "profile_terms_service"
    static let profileReadTerms = "profile_read_terms"
    static let profilePrivacyPolicy = "profile_privacy_policy"
    static let profileReadPrivacy = "profile_read_privacy"
    
    // MARK: - Lesson Categories
    static let categoryBasics = "category_basics"
    static let categoryTechnique = "category_technique"
    static let categoryTheory = "category_theory"
    static let categoryScales = "category_scales"
    static let categoryChords = "category_chords"
    static let categoryRhythm = "category_rhythm"
    static let categorySongs = "category_songs"
    static let categoryAdvanced = "category_advanced"
    
    // MARK: - Theory Categories
    static let theoryNotation = "theory_notation"
    static let theoryRhythm = "theory_rhythm"
    static let theoryHarmony = "theory_harmony"
    static let theoryMelody = "theory_melody"
    static let theoryForm = "theory_form"
    static let theoryEarTraining = "theory_ear_training"
    
    // MARK: - Difficulty Levels
    static let difficultyBeginner = "difficulty_beginner"
    static let difficultyIntermediate = "difficulty_intermediate"
    static let difficultyAdvanced = "difficulty_advanced"
    static let difficultyExpert = "difficulty_expert"
    
    // MARK: - Common Actions
    static let actionOk = "action_ok"
    static let actionCancel = "action_cancel"
    static let actionDone = "action_done"
    static let actionSave = "action_save"
    static let actionDelete = "action_delete"
    static let actionEdit = "action_edit"
    static let actionClose = "action_close"
    static let actionBack = "action_back"
    static let actionNext = "action_next"
    static let actionPrevious = "action_previous"
    static let actionPlay = "action_play"
    static let actionPause = "action_pause"
    static let actionStop = "action_stop"
    static let actionRecord = "action_record"
    
    // MARK: - Time Units
    static let timeMinutes = "time_minutes"
    static let timeHours = "time_hours"
    static let timeDays = "time_days"
    static let timeWeeks = "time_weeks"
    static let timeMonths = "time_months"
    static let timeYears = "time_years"
    
    // MARK: - Status Messages
    static let statusLoading = "status_loading"
    static let statusSaving = "status_saving"
    static let statusUploading = "status_uploading"
    static let statusDownloading = "status_downloading"
    static let statusProcessing = "status_processing"
    static let statusCompleted = "status_completed"
    static let statusFailed = "status_failed"
    static let statusSuccess = "status_success"
    static let statusError = "status_error"
    static let statusUnknown = "status_unknown"
    
    // MARK: - Error Messages
    static let errorGeneric = "error_generic"
    static let errorNetwork = "error_network"
    static let errorAuthFailed = "error_auth_failed"
    static let errorInvalidEmail = "error_invalid_email"
    static let errorWeakPassword = "error_weak_password"
    static let errorEmailInUse = "error_email_in_use"
    static let errorUserNotFound = "error_user_not_found"
    static let errorWrongPassword = "error_wrong_password"
    
    // MARK: - Success Messages
    static let successAccountCreated = "success_account_created"
    static let successPasswordReset = "success_password_reset"
    static let successProfileUpdated = "success_profile_updated"
    static let successLessonCompleted = "success_lesson_completed"
    static let successAchievementUnlocked = "success_achievement_unlocked"
    
    // MARK: - Placeholder Text
    static let placeholderSearch = "placeholder_search"
    static let placeholderEnterText = "placeholder_enter_text"
    static let placeholderSelectOption = "placeholder_select_option"
    static let placeholderNoData = "placeholder_no_data"
    static let placeholderNoResults = "placeholder_no_results"
}
