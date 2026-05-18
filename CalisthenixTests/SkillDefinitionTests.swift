import Testing
@testable import Calisthenix

@Suite("SkillDefinition")
struct SkillDefinitionTests {
    @Test("Step has unique ID")
    func stepHasUniqueID() {
        let step1 = Step(id: "s1", name: "Step 1", skillID: "test", description: "", formCues: ["cue"], commonMistakes: ["mistake"], prerequisiteIDs: [], movementCategory: .legs, recommendedMethod: .greaseTheGroove, advancementCriteria: AdvancementCriteria(sets: 3, reps: 15, sessionsRequired: 2))
        let step2 = Step(id: "s2", name: "Step 2", skillID: "test", description: "", formCues: ["cue"], commonMistakes: ["mistake"], prerequisiteIDs: ["s1"], movementCategory: .legs, recommendedMethod: .greaseTheGroove, advancementCriteria: AdvancementCriteria(sets: 3, reps: 12, sessionsRequired: 2))
        #expect(step1.id != step2.id)
    }

    @Test("Step prerequisite references")
    func stepPrerequisiteReferences() {
        let step = Step(id: "s2", name: "Step 2", skillID: "test", description: "", formCues: ["cue"], commonMistakes: ["mistake"], prerequisiteIDs: ["s1"], movementCategory: .legs, recommendedMethod: .greaseTheGroove, advancementCriteria: AdvancementCriteria(sets: 3, reps: 12, sessionsRequired: 2))
        #expect(step.prerequisiteIDs.count == 1)
        #expect(step.prerequisiteIDs.first == "s1")
    }

    @Test("Skill groups steps and finds root")
    func skillGroupsSteps() {
        let steps = [
            Step(id: "s1", name: "Step 1", skillID: "test", description: "", formCues: ["cue"], commonMistakes: ["mistake"], prerequisiteIDs: [], movementCategory: .legs, recommendedMethod: .greaseTheGroove, advancementCriteria: AdvancementCriteria(sets: 3, reps: 10, sessionsRequired: 2)),
            Step(id: "s2", name: "Step 2", skillID: "test", description: "", formCues: ["cue"], commonMistakes: ["mistake"], prerequisiteIDs: ["s1"], movementCategory: .legs, recommendedMethod: .structured, advancementCriteria: AdvancementCriteria(sets: 3, reps: 8, sessionsRequired: 2))
        ]
        let skill = Skill(id: "test", name: "Test", description: "A test", isPremium: false, steps: steps)
        #expect(skill.steps.count == 2)
        #expect(skill.rootSteps.count == 1)
        #expect(skill.rootSteps.first?.id == "s1")
    }

    @Test("AdvancementCriteria with hold duration")
    func advancementCriteriaHold() {
        let criteria = AdvancementCriteria(sets: 5, holdSeconds: 10, sessionsRequired: 3)
        #expect(criteria.reps == nil)
        #expect(criteria.holdSeconds == 10)
    }

    @Test("MovementCategory split groups")
    func movementCategorySplit() {
        #expect(MovementCategory.push.splitGroup == .upper)
        #expect(MovementCategory.pull.splitGroup == .upper)
        #expect(MovementCategory.legs.splitGroup == .lower)
        #expect(MovementCategory.skill.splitGroup == .upper)
    }
}
