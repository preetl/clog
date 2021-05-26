//import ResearchKit
//
//public var SurveyTask: ORKOrderedTask {
//
//    var steps = [ORKStep]()
//
//    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
//    instructionStep.title = "Daily Questionnaire"
//    instructionStep.text = "Please answer these questions as accurately as you can."
//    steps += [instructionStep]
//
//    let sleepAnswerFormat: ORKTimeIntervalAnswerFormat = ORKTimeIntervalAnswerFormat(defaultInterval: 7, step: 15)
//    let sleepQuestionTitle = "How long did you sleep last night?"
//    let sleepQuestion = ORKQuestionStep(identifier:"sleepQuestion", title: "", question: sleepQuestionTitle, answer: sleepAnswerFormat)
//    sleepQuestion.isOptional = false
//    steps += [sleepQuestion]
//
//    let phonebedAnswerFormat: ORKTimeIntervalAnswerFormat = ORKTimeIntervalAnswerFormat(defaultInterval: 7, step: 15)
//    let phonebedQuestionTitle = "How long did you use your phone in bed last night?"
//    let phonebedQuestion = ORKQuestionStep(identifier:"phonebedQuestion", title: "", question: phonebedQuestionTitle, answer: phonebedAnswerFormat)
//    phonebedQuestion.isOptional = false
//    steps += [phonebedQuestion]
//
//    let sleepQualityAnswerFormat: ORKScaleAnswerFormat = ORKScaleAnswerFormat(maximumValue: 10, minimumValue: 1, defaultValue: 5, step: 1)
//    let sleepQualityQuestionTitle = "How would you rate last night's sleep?"
//    let sleepQualityQuestion = ORKQuestionStep(identifier:"sleepQualityQuestion", title: "", question: sleepQualityQuestionTitle, answer: sleepQualityAnswerFormat)
//    sleepQualityQuestion.isOptional = false
//    steps += [sleepQualityQuestion]
//
//    let anxietyQuestionTitle = "Have you felt nervous, anxious or on edge today?"
//    let anxietyQuestion = ORKQuestionStep(identifier:"anxietyQuestion", title: "", question: anxietyQuestionTitle, answer: ORKBooleanAnswerFormat())
//    anxietyQuestion.isOptional = false
//    steps += [anxietyQuestion]
//
//    let worryQuestionTitle = "Have you felt unable to stop or control worrying today?"
//    let worryQuestion = ORKQuestionStep(identifier:"worryQuestion", title: "", question: worryQuestionTitle, answer: ORKBooleanAnswerFormat())
//    worryQuestion.isOptional = false
//    steps += [worryQuestion]
//
//    let interestQuestionTitle = "Have you felt little interest or pleasure in doing things today?"
//    let interestQuestion = ORKQuestionStep(identifier:"interestQuestion", title: "", question: interestQuestionTitle, answer: ORKBooleanAnswerFormat())
//    interestQuestion.isOptional = false
//    steps += [interestQuestion]
//
//    let downQuestionTitle = "Have you felt down or hopeless today?"
//    let downQuestion = ORKQuestionStep(identifier:"downQuestion", title: "", question: downQuestionTitle, answer: ORKBooleanAnswerFormat())
//    downQuestion.isOptional = false
//    steps += [downQuestion]
//
//    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
//    summaryStep.title = "Thank you!"
//    summaryStep.text = ""
//    steps += [summaryStep]
//
//  return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
//}
