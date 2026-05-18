import Foundation

enum SkillCatalog {

    static let all: [Skill] = [
        pistolSquat,
        pushUpProgression,
        muscleUp,
        nordicCurls,
        handstand,
        planche
    ]

    static func skill(byID id: String) -> Skill? {
        all.first { $0.id == id }
    }

    // MARK: - Pistol Squat

    static let pistolSquat = Skill(
        id: "pistol-squat",
        name: "Pistol Squat",
        description: "Single-leg strength and balance",
        isPremium: false,
        steps: [
            Step(id: "ps-bw-squat", name: "Bodyweight Squat", skillID: "pistol-squat",
                 description: "Foundation bilateral squat pattern",
                 formCues: ["Feet shoulder width apart", "Break at hips and knees together", "Chest stays tall", "Knees track over toes"],
                 commonMistakes: ["Knees caving inward", "Rising onto toes", "Excessive forward lean"],
                 prerequisiteIDs: [], movementCategory: .legs, recommendedMethod: .greaseTheGroove,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 20, sessionsRequired: 2)),

            Step(id: "ps-box-squat", name: "Box Squat", skillID: "pistol-squat",
                 description: "Controlled depth with a target — builds confidence at bottom range",
                 formCues: ["Lower under control to the box", "Light touch, don't sit", "Drive through whole foot to stand"],
                 commonMistakes: ["Plopping onto the box", "Rocking forward to stand"],
                 prerequisiteIDs: ["ps-bw-squat"], movementCategory: .legs, recommendedMethod: .greaseTheGroove,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 15, sessionsRequired: 2)),

            Step(id: "ps-bulgarian", name: "Bulgarian Split Squat", skillID: "pistol-squat",
                 description: "Single-leg loading with rear foot elevated",
                 formCues: ["Rear foot on bench, laces down", "Torso upright", "Front knee tracks over toes", "Lower until rear knee nears floor"],
                 commonMistakes: ["Standing too close to bench", "Leaning forward excessively"],
                 prerequisiteIDs: ["ps-box-squat"], movementCategory: .legs, recommendedMethod: .structured,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 12, sessionsRequired: 2)),

            Step(id: "ps-assisted", name: "Assisted Pistol Squat", skillID: "pistol-squat",
                 description: "Full pistol pattern with hand support for balance",
                 formCues: ["Hold a pole or door frame lightly", "Extend free leg forward", "Sit deep into the squat", "Use minimal hand assistance"],
                 commonMistakes: ["Pulling with the arms", "Not going to full depth"],
                 prerequisiteIDs: ["ps-bulgarian"], movementCategory: .legs, recommendedMethod: .structured,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 8, sessionsRequired: 3)),

            Step(id: "ps-wide-archer", name: "Wide Archer Squat", skillID: "pistol-squat",
                 description: "Wide stance with weight shifting to one leg",
                 formCues: ["Wide stance, toes slightly out", "Shift weight to working leg", "Straight leg stays extended", "Keep heel down on working leg"],
                 commonMistakes: ["Bending the straight leg", "Insufficient depth"],
                 prerequisiteIDs: ["ps-bulgarian"], movementCategory: .legs, recommendedMethod: .structured,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 10, sessionsRequired: 2)),

            Step(id: "ps-eccentric", name: "Eccentric Pistol Squat", skillID: "pistol-squat",
                 description: "Slow controlled lowering on one leg — builds strength at weakest point",
                 formCues: ["Stand on one leg, arms forward", "Lower over 3-5 seconds", "Control all the way to bottom", "Use both legs to stand back up"],
                 commonMistakes: ["Dropping too fast", "Losing balance sideways"],
                 prerequisiteIDs: ["ps-assisted"], movementCategory: .legs, recommendedMethod: .structured,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 5, sessionsRequired: 3)),

            Step(id: "ps-archer", name: "Archer Squat", skillID: "pistol-squat",
                 description: "Deep single-leg squat with straight assist leg — near-full pistol loading",
                 formCues: ["Working leg takes almost all weight", "Assist leg stays straight and flat", "Full depth on working side", "Hip rotation control throughout"],
                 commonMistakes: ["Using assist leg too much", "Heel lifting on working leg"],
                 prerequisiteIDs: ["ps-wide-archer"], movementCategory: .legs, recommendedMethod: .structured,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 8, sessionsRequired: 3)),

            Step(id: "ps-full", name: "Pistol Squat", skillID: "pistol-squat",
                 description: "Full single-leg squat — the goal",
                 formCues: ["Arms forward for counterbalance", "Free leg extended straight", "Full depth — hamstring to calf", "Stand up with control"],
                 commonMistakes: ["Falling backward at bottom", "Free leg dropping"],
                 prerequisiteIDs: ["ps-eccentric", "ps-archer"], movementCategory: .legs, recommendedMethod: .skillPractice,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 5, sessionsRequired: 5)),
        ]
    )

    // MARK: - Push-Up Progression

    static let pushUpProgression = Skill(
        id: "push-up-progression",
        name: "Single Arm Push-Up",
        description: "Pushing strength toward single arm, single leg push-up",
        isPremium: false,
        steps: [
            Step(id: "pu-standard", name: "Push-Up", skillID: "push-up-progression",
                 description: "Standard push-up with full range of motion",
                 formCues: ["Hands shoulder width", "Body rigid — plank position", "Chest to floor", "Elbows at 45 degrees"],
                 commonMistakes: ["Hips sagging", "Flaring elbows to 90 degrees", "Partial range of motion"],
                 prerequisiteIDs: [], movementCategory: .push, recommendedMethod: .greaseTheGroove,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 20, sessionsRequired: 2)),

            Step(id: "pu-diamond", name: "Diamond Push-Up", skillID: "push-up-progression",
                 description: "Close hand placement for tricep and inner chest emphasis",
                 formCues: ["Hands together under chest, thumbs touching", "Elbows stay close to body", "Full range of motion"],
                 commonMistakes: ["Hands too far forward", "Flaring elbows out"],
                 prerequisiteIDs: ["pu-standard"], movementCategory: .push, recommendedMethod: .greaseTheGroove,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 15, sessionsRequired: 2)),

            Step(id: "pu-decline", name: "Decline Push-Up", skillID: "push-up-progression",
                 description: "Feet elevated for increased upper chest and shoulder loading",
                 formCues: ["Feet on bench or step", "Hands slightly wider than shoulders", "Body straight from head to heels"],
                 commonMistakes: ["Hips piking up", "Not going to full depth"],
                 prerequisiteIDs: ["pu-standard"], movementCategory: .push, recommendedMethod: .structured,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 15, sessionsRequired: 2)),

            Step(id: "pu-archer", name: "Archer Push-Up", skillID: "push-up-progression",
                 description: "One arm does most of the work — bridges to single arm",
                 formCues: ["Wide hand placement", "Working arm bends, assist arm stays straight", "Chest to working hand", "Rotate body slightly toward working arm"],
                 commonMistakes: ["Bending assist arm", "Insufficient depth on working side"],
                 prerequisiteIDs: ["pu-diamond"], movementCategory: .push, recommendedMethod: .structured,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 8, sessionsRequired: 3)),

            Step(id: "pu-single-leg", name: "Single Leg Push-Up", skillID: "push-up-progression",
                 description: "Standard push-up with one foot lifted — builds anti-rotation core",
                 formCues: ["Lift one foot off ground", "Keep hips square — no rotation", "Standard push-up form otherwise"],
                 commonMistakes: ["Hips rotating open", "Raised leg swinging for momentum"],
                 prerequisiteIDs: ["pu-decline"], movementCategory: .push, recommendedMethod: .structured,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 10, sessionsRequired: 3)),

            Step(id: "pu-one-arm", name: "One-Arm Push-Up", skillID: "push-up-progression",
                 description: "Full push-up on a single arm — advanced pushing strength",
                 formCues: ["Feet wide for stability", "Working hand under chest", "Lower under control", "Free hand behind back"],
                 commonMistakes: ["Body twisting open", "Partial range of motion"],
                 prerequisiteIDs: ["pu-archer"], movementCategory: .push, recommendedMethod: .skillPractice,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 5, sessionsRequired: 3)),

            Step(id: "pu-sa-sl", name: "Single Arm Single Leg Push-Up", skillID: "push-up-progression",
                 description: "The ultimate bodyweight push — single arm, opposite leg raised",
                 formCues: ["Opposite arm and leg working", "Maximum core anti-rotation", "Controlled descent and push", "Squeeze glutes for stability"],
                 commonMistakes: ["Collapsing to one side", "Using momentum instead of control"],
                 prerequisiteIDs: ["pu-one-arm", "pu-single-leg"], movementCategory: .push, recommendedMethod: .skillPractice,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 3, sessionsRequired: 5)),
        ]
    )

    // MARK: - Muscle-Up

    static let muscleUp = Skill(
        id: "muscle-up",
        name: "Muscle-Up",
        description: "Pulling power and transition strength",
        isPremium: true,
        steps: [
            Step(id: "mu-pullup", name: "Pull-Up", skillID: "muscle-up",
                 description: "Strict pull-up with full range of motion",
                 formCues: ["Dead hang start", "Pull elbows to ribs", "Chin clears bar", "Lower under control"],
                 commonMistakes: ["Kipping or swinging", "Partial range — not full hang"],
                 prerequisiteIDs: [], movementCategory: .pull, recommendedMethod: .greaseTheGroove,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 10, sessionsRequired: 3)),

            Step(id: "mu-chest-bar", name: "Chest-to-Bar Pull-Up", skillID: "muscle-up",
                 description: "Higher pull — building the pull height needed for the transition",
                 formCues: ["Pull until chest touches bar", "Slight lean back at top", "Aggressive lat engagement"],
                 commonMistakes: ["Only chin height", "Excessive kipping"],
                 prerequisiteIDs: ["mu-pullup"], movementCategory: .pull, recommendedMethod: .structured,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 8, sessionsRequired: 3)),

            Step(id: "mu-straight-dip", name: "Straight Bar Dip", skillID: "muscle-up",
                 description: "Dip on a straight bar — builds the top half of the muscle-up",
                 formCues: ["Bar at hip crease", "Lower until arms at 90 degrees", "Push up to full lockout", "Lean slightly forward"],
                 commonMistakes: ["Not going deep enough", "Bar rolling on hands"],
                 prerequisiteIDs: ["mu-pullup"], movementCategory: .pull, recommendedMethod: .structured,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 10, sessionsRequired: 3)),

            Step(id: "mu-high-pull", name: "High Pull-Up", skillID: "muscle-up",
                 description: "Explosive pull to waist height — almost the full pull phase",
                 formCues: ["Explosive pull from dead hang", "Pull bar toward belly button", "Quick hip snap to assist"],
                 commonMistakes: ["Not pulling high enough", "Pure arms, no hip involvement"],
                 prerequisiteIDs: ["mu-chest-bar"], movementCategory: .pull, recommendedMethod: .structured,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 5, sessionsRequired: 3)),

            Step(id: "mu-negative", name: "Negative Muscle-Up", skillID: "muscle-up",
                 description: "Jump or assist to top, lower through the transition slowly",
                 formCues: ["Start in support above bar", "Lower through transition over 3-5 seconds", "Control the whole way to dead hang"],
                 commonMistakes: ["Dropping through transition", "Not controlling the negative"],
                 prerequisiteIDs: ["mu-high-pull", "mu-straight-dip"], movementCategory: .pull, recommendedMethod: .skillPractice,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 3, sessionsRequired: 5)),

            Step(id: "mu-full", name: "Strict Muscle-Up", skillID: "muscle-up",
                 description: "Full muscle-up from dead hang to support — the goal",
                 formCues: ["Dead hang, false grip recommended", "Explosive pull with hip drive", "Fast transition — wrists roll over bar", "Press to full support"],
                 commonMistakes: ["Chicken winging one arm", "No false grip — slipping"],
                 prerequisiteIDs: ["mu-negative"], movementCategory: .pull, recommendedMethod: .skillPractice,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 3, sessionsRequired: 5)),
        ]
    )

    // MARK: - Nordic Curls

    static let nordicCurls = Skill(
        id: "nordic-curls",
        name: "Nordic Curl",
        description: "Posterior chain and hamstring strength",
        isPremium: false,
        steps: [
            Step(id: "nc-swiss-curl", name: "Swiss Ball Hamstring Curl", skillID: "nordic-curls",
                 description: "Supine hamstring curl with stability ball",
                 formCues: ["Lie on back, heels on ball", "Lift hips into bridge", "Curl ball toward glutes", "Hips stay elevated throughout"],
                 commonMistakes: ["Hips dropping between reps", "Using momentum to curl"],
                 prerequisiteIDs: [], movementCategory: .legs, recommendedMethod: .greaseTheGroove,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 15, sessionsRequired: 2)),

            Step(id: "nc-slider-curl", name: "Slider Hamstring Curl", skillID: "nordic-curls",
                 description: "Supine curl on sliders — harder than ball due to less instability assistance",
                 formCues: ["Heels on sliders or towel", "Bridge up, slide heels out and in", "Control the eccentric slide-out"],
                 commonMistakes: ["Hips dropping during slide-out", "Going too fast"],
                 prerequisiteIDs: ["nc-swiss-curl"], movementCategory: .legs, recommendedMethod: .structured,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 12, sessionsRequired: 2)),

            Step(id: "nc-eccentric", name: "Eccentric Nordic Curl", skillID: "nordic-curls",
                 description: "Kneeling, lower body forward as slowly as possible",
                 formCues: ["Kneel with ankles anchored", "Body straight from knees to head", "Lower slowly — fight gravity the whole way", "Catch yourself at bottom, reset to top"],
                 commonMistakes: ["Bending at the hips", "Falling too fast"],
                 prerequisiteIDs: ["nc-slider-curl"], movementCategory: .legs, recommendedMethod: .structured,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 6, sessionsRequired: 3)),

            Step(id: "nc-band-assisted", name: "Band-Assisted Nordic Curl", skillID: "nordic-curls",
                 description: "Full Nordic with a resistance band reducing load at the hardest point",
                 formCues: ["Band around chest, anchored above/behind", "Lower and pull yourself back up", "Full range of motion", "Band takes edge off the hardest part"],
                 commonMistakes: ["Band too strong — no challenge", "Bending at hips"],
                 prerequisiteIDs: ["nc-eccentric"], movementCategory: .legs, recommendedMethod: .structured,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 8, sessionsRequired: 3)),

            Step(id: "nc-partial", name: "Partial Nordic Curl", skillID: "nordic-curls",
                 description: "Lower partway and pull back up without assistance",
                 formCues: ["Kneel with ankles anchored", "Lower to roughly 45 degrees", "Pull back up with hamstrings", "Increase depth as you get stronger"],
                 commonMistakes: ["Using hands to push back up", "Hips breaking the line"],
                 prerequisiteIDs: ["nc-band-assisted"], movementCategory: .legs, recommendedMethod: .structured,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 8, sessionsRequired: 3)),

            Step(id: "nc-full", name: "Full Nordic Curl", skillID: "nordic-curls",
                 description: "Full range Nordic — lower to floor and pull back up",
                 formCues: ["Ankles anchored firmly", "Straight line knees to head", "Lower all the way to floor under control", "Pull back up using only hamstrings"],
                 commonMistakes: ["Bending at hips on the way up", "Using hands to assist"],
                 prerequisiteIDs: ["nc-partial"], movementCategory: .legs, recommendedMethod: .skillPractice,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 5, sessionsRequired: 5)),
        ]
    )

    // MARK: - Handstand

    static let handstand = Skill(
        id: "handstand",
        name: "Handstand",
        description: "Balance, overhead stability, and body control",
        isPremium: true,
        steps: [
            Step(id: "hs-wall-plank", name: "Wall Plank", skillID: "handstand",
                 description: "Feet on wall, hands on floor — builds overhead endurance",
                 formCues: ["Walk feet up wall to roughly 45 degrees", "Arms straight, push floor away", "Hollow body — ribs tucked"],
                 commonMistakes: ["Arching lower back", "Bent arms"],
                 prerequisiteIDs: [], movementCategory: .skill, recommendedMethod: .greaseTheGroove,
                 advancementCriteria: AdvancementCriteria(sets: 3, holdSeconds: 30, sessionsRequired: 3)),

            Step(id: "hs-chest-wall", name: "Chest-to-Wall Handstand", skillID: "handstand",
                 description: "Facing the wall, walk up until nearly vertical",
                 formCues: ["Face wall, walk feet up until chest near wall", "Hands 6-12 inches from wall", "Push through shoulders — full extension", "Tuck ribs, point toes"],
                 commonMistakes: ["Banana back — arching", "Hands too far from wall"],
                 prerequisiteIDs: ["hs-wall-plank"], movementCategory: .skill, recommendedMethod: .skillPractice,
                 advancementCriteria: AdvancementCriteria(sets: 3, holdSeconds: 30, sessionsRequired: 5)),

            Step(id: "hs-back-wall", name: "Back-to-Wall Handstand", skillID: "handstand",
                 description: "Kick up with back to wall — more freestanding-like alignment",
                 formCues: ["Kick up to wall with back facing it", "Only heels lightly touch wall", "Find balance point — minimal wall contact", "Hollow body throughout"],
                 commonMistakes: ["Leaning into wall too much", "Arching to reach wall"],
                 prerequisiteIDs: ["hs-chest-wall"], movementCategory: .skill, recommendedMethod: .skillPractice,
                 advancementCriteria: AdvancementCriteria(sets: 5, holdSeconds: 20, sessionsRequired: 5)),

            Step(id: "hs-toe-pull", name: "Toe Pulls", skillID: "handstand",
                 description: "Back to wall, pull toes off wall to find balance",
                 formCues: ["Start in back-to-wall handstand", "Gently pull toes from wall", "Hold freestanding as long as possible", "Return to wall when losing balance"],
                 commonMistakes: ["Kicking off wall too hard", "Not finding the balance point"],
                 prerequisiteIDs: ["hs-back-wall"], movementCategory: .skill, recommendedMethod: .skillPractice,
                 advancementCriteria: AdvancementCriteria(sets: 5, holdSeconds: 10, sessionsRequired: 5)),

            Step(id: "hs-shoulder-taps", name: "Wall Handstand Shoulder Taps", skillID: "handstand",
                 description: "Builds single-arm stability and weight shift control",
                 formCues: ["Chest-to-wall handstand", "Shift weight to one arm", "Lift opposite hand, touch shoulder", "Alternate with control"],
                 commonMistakes: ["Rushing the taps", "Falling sideways"],
                 prerequisiteIDs: ["hs-back-wall"], movementCategory: .skill, recommendedMethod: .skillPractice,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 6, sessionsRequired: 5)),

            Step(id: "hs-freestanding", name: "Freestanding Handstand", skillID: "handstand",
                 description: "Balanced handstand without wall support — the goal",
                 formCues: ["Kick up with control", "Stacked alignment — wrists, shoulders, hips, toes", "Correct with fingers (overbalance) and palms (underbalance)", "Breathe steadily"],
                 commonMistakes: ["Kicking up too hard", "Arched banana shape", "Holding breath"],
                 prerequisiteIDs: ["hs-toe-pull", "hs-shoulder-taps"], movementCategory: .skill, recommendedMethod: .skillPractice,
                 advancementCriteria: AdvancementCriteria(sets: 3, holdSeconds: 30, sessionsRequired: 5)),
        ]
    )

    // MARK: - Planche

    static let planche = Skill(
        id: "planche",
        name: "Planche",
        description: "Advanced pushing and core strength",
        isPremium: true,
        steps: [
            Step(id: "pl-plank", name: "Plank", skillID: "planche",
                 description: "Foundation core hold — proper hollow body position",
                 formCues: ["Forearms or hands on floor", "Body rigid — straight line", "Tuck ribs, squeeze glutes", "Push floor away through shoulders"],
                 commonMistakes: ["Hips sagging", "Looking up — neck neutral instead"],
                 prerequisiteIDs: [], movementCategory: .push, recommendedMethod: .greaseTheGroove,
                 advancementCriteria: AdvancementCriteria(sets: 3, holdSeconds: 60, sessionsRequired: 2)),

            Step(id: "pl-pseudo-lean", name: "Pseudo Planche Lean", skillID: "planche",
                 description: "Push-up position with hands turned out, leaning forward past hands",
                 formCues: ["Hands at hip level, fingers pointing sideways or back", "Lean forward until shoulders are ahead of wrists", "Straight arms, locked elbows", "Hollow body — protracted shoulders"],
                 commonMistakes: ["Bending elbows", "Not leaning far enough forward"],
                 prerequisiteIDs: ["pl-plank"], movementCategory: .push, recommendedMethod: .skillPractice,
                 advancementCriteria: AdvancementCriteria(sets: 5, holdSeconds: 15, sessionsRequired: 5)),

            Step(id: "pl-lean-pushup", name: "Planche Lean Push-Up", skillID: "planche",
                 description: "Push-ups in the lean position — builds specific pressing strength",
                 formCues: ["Start in pseudo planche lean", "Bend elbows while maintaining forward lean", "Push back to straight arms", "Elbows stay close to body"],
                 commonMistakes: ["Losing the lean during the push", "Elbows flaring"],
                 prerequisiteIDs: ["pl-pseudo-lean"], movementCategory: .push, recommendedMethod: .structured,
                 advancementCriteria: AdvancementCriteria(sets: 3, reps: 8, sessionsRequired: 3)),

            Step(id: "pl-tuck", name: "Tuck Planche", skillID: "planche",
                 description: "Planche with knees tucked to chest — first freestanding planche variant",
                 formCues: ["Hands on floor or parallettes", "Lean forward, lift feet off ground", "Knees tucked tight to chest", "Round upper back, protract shoulders"],
                 commonMistakes: ["Knees not tucked tight enough", "Insufficient forward lean"],
                 prerequisiteIDs: ["pl-pseudo-lean"], movementCategory: .push, recommendedMethod: .skillPractice,
                 advancementCriteria: AdvancementCriteria(sets: 5, holdSeconds: 10, sessionsRequired: 5)),

            Step(id: "pl-adv-tuck", name: "Advanced Tuck Planche", skillID: "planche",
                 description: "Tuck planche with hips raised to back-level — flat back position",
                 formCues: ["From tuck planche, raise hips until back is flat", "Knees still tucked but hips at shoulder height", "Intense shoulder and core engagement"],
                 commonMistakes: ["Hips too low — still in basic tuck", "Losing protraction"],
                 prerequisiteIDs: ["pl-tuck", "pl-lean-pushup"], movementCategory: .push, recommendedMethod: .skillPractice,
                 advancementCriteria: AdvancementCriteria(sets: 5, holdSeconds: 10, sessionsRequired: 5)),

            Step(id: "pl-straddle", name: "Straddle Planche", skillID: "planche",
                 description: "Legs extended and straddled — significant lever increase",
                 formCues: ["From advanced tuck, extend legs out to sides", "Wide straddle for shorter lever", "Hips at shoulder height", "Straight arms, maximum protraction"],
                 commonMistakes: ["Legs not fully extended", "Hips dropping below shoulders"],
                 prerequisiteIDs: ["pl-adv-tuck"], movementCategory: .push, recommendedMethod: .skillPractice,
                 advancementCriteria: AdvancementCriteria(sets: 3, holdSeconds: 10, sessionsRequired: 5)),

            Step(id: "pl-full", name: "Full Planche", skillID: "planche",
                 description: "Legs together, body horizontal, straight arms — the goal",
                 formCues: ["Legs together, fully extended behind", "Body completely horizontal", "Straight arms locked at elbows", "Maximum shoulder protraction and depression"],
                 commonMistakes: ["Piking at hips", "Arms bending under load"],
                 prerequisiteIDs: ["pl-straddle"], movementCategory: .push, recommendedMethod: .skillPractice,
                 advancementCriteria: AdvancementCriteria(sets: 3, holdSeconds: 5, sessionsRequired: 5)),
        ]
    )
}
