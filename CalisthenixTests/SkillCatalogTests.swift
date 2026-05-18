import Testing
@testable import Calisthenix

@Suite("SkillCatalog")
struct SkillCatalogTests {

    @Test("Catalog contains exactly 6 skills")
    func catalogHasSixSkills() {
        #expect(SkillCatalog.all.count == 6)
    }

    @Test("All step IDs are unique across entire catalog")
    func allStepIDsUnique() {
        let allSteps = SkillCatalog.all.flatMap(\.steps)
        let ids = allSteps.map(\.id)
        let uniqueIDs = Set(ids)
        #expect(ids.count == uniqueIDs.count, "Duplicate step IDs found")
    }

    @Test("All prerequisite IDs reference existing steps within same skill")
    func prerequisitesReferenceValidSteps() {
        for skill in SkillCatalog.all {
            let stepIDs = Set(skill.steps.map(\.id))
            for step in skill.steps {
                for prereq in step.prerequisiteIDs {
                    #expect(stepIDs.contains(prereq), "Step \(step.id) references unknown prerequisite \(prereq)")
                }
            }
        }
    }

    @Test("Every skill has at least one root step")
    func everySkillHasRoot() {
        for skill in SkillCatalog.all {
            #expect(!skill.rootSteps.isEmpty, "Skill \(skill.id) has no root step")
        }
    }

    @Test("No cycles in prerequisite graph")
    func noCyclesInGraph() {
        for skill in SkillCatalog.all {
            var visited = Set<String>()
            var stack = Set<String>()

            func hasCycle(_ stepID: String) -> Bool {
                if stack.contains(stepID) { return true }
                if visited.contains(stepID) { return false }
                visited.insert(stepID)
                stack.insert(stepID)
                for child in skill.children(of: stepID) {
                    if hasCycle(child.id) { return true }
                }
                stack.remove(stepID)
                return false
            }

            for step in skill.rootSteps {
                #expect(!hasCycle(step.id), "Cycle detected in skill \(skill.id)")
            }
        }
    }

    @Test("Free skills are pistol squat, push-up, nordic curls")
    func freeSkillsCorrect() {
        let free = SkillCatalog.all.filter { !$0.isPremium }
        let freeIDs = Set(free.map(\.id))
        #expect(freeIDs == Set(["pistol-squat", "push-up-progression", "nordic-curls"]))
    }

    @Test("Premium skills are muscle-up, handstand, planche")
    func premiumSkillsCorrect() {
        let premium = SkillCatalog.all.filter(\.isPremium)
        let premiumIDs = Set(premium.map(\.id))
        #expect(premiumIDs == Set(["muscle-up", "handstand", "planche"]))
    }

    @Test("Each step has at least one form cue")
    func stepsHaveFormCues() {
        for skill in SkillCatalog.all {
            for step in skill.steps {
                #expect(!step.formCues.isEmpty, "Step \(step.id) has no form cues")
            }
        }
    }
}
