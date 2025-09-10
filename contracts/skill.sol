// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedSkillVerification {

    struct Skill {
        string skillName;
        uint256 verifiedAt;
        address verifier;
    }

    mapping(address => Skill[]) private userSkills;

    event SkillAdded(address indexed user, string skillName, address indexed verifier);
    event SkillRemoved(address indexed user, string skillName);

    // Add a skill verified by a verifier (could be an employer, educator, or peer)
    function addSkill(address user, string memory skillName) public {
        Skill memory newSkill = Skill({
            skillName: skillName,
            verifiedAt: block.timestamp,
            verifier: msg.sender
        });

        userSkills[user].push(newSkill);
        emit SkillAdded(user, skillName, msg.sender);
    }

    // Get all skills of a user
    function getSkills(address user) public view returns (Skill[] memory) {
        return userSkills[user];
    }

    // Remove a skill by its name (only verifier can remove)
    function removeSkill(address user, string memory skillName) public {
        Skill[] storage skills = userSkills[user];
        for (uint i = 0; i < skills.length; i++) {
            if (keccak256(bytes(skills[i].skillName)) == keccak256(bytes(skillName))) {
                require(skills[i].verifier == msg.sender, "Only verifier can remove this skill");
                skills[i] = skills[skills.length - 1];
                skills.pop();
                emit SkillRemoved(user, skillName);
                break;
            }
        }
    }
}
