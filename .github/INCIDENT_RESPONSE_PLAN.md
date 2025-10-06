# Incident Response Plan

## Reporting a Vulnerability

Please see [the latest guidelines](https://github.com/ohmyzsh/ohmyzsh/blob/master/SECURITY.md) for instructions.

## Phases

### Triage

1. Is this a valid security vulnerability?

  - [ ] It affects our CI/CD or any of our repositories.
    - [ ] For ohmyzsh/ohmyzsh, it affects the latest commit.
    - [ ] For others, it affects the latest commit on the default branch.
  - [ ] It affects a third-party dependency:
    - [ ] Zsh or git
    - [ ] For a plugin, the vulnerability is a result of our usage of the dependency.

2. What's the scope of the vulnerability?

  - [ ] Our codebase.
  - [ ] A direct third-party dependency (Zsh, git, other plugins).
  - [ ] An indirect third-party dependency.
  - [ ] Out of scope, a third-party dependency that is the responsibility of the user.
  - [ ] Out of scope, any other case (edit this plan and add the details).

3. Is the vulnerability actionable?

  - [ ] Yes, we can submit a fix.
  - [ ] Yes, we can disable a feature.
  - [ ] Yes, we can mitigate the risk.
  - [ ] Yes, we can remove a vulnerable dependency.
  - [ ] Yes, we can apply a workaround.
  - [ ] Yes, we can apply a patch to a vulnerable dependency ([example for CVE-2021-45444](https://github.com/ohmyzsh/ohmyzsh/blob/cb72d7dcbf08b435c7f8a6470802b207b2aa02c3/lib/vcs_info.zsh)).
  - [ ] No, the vulnerability is not actionable.

4. What's the impact of the vulnerability?

  Assess using the *CIA* triad:

  - **Confidentiality**: example: report or sharing of secrets.
  - **Integrity**: affects the integrity of the system (deletion, corruption or encryption of data, OS file corruption, etc.).
  - **Availability**: denial of login, deletion of required files to boot / login, etc.

5. What's the exploitability of the vulnerability?

  Consider how easy it is to exploit, and if it affects all users or requires specific configurations.

6. What's the severity of the vulnerability?

  You can use the [CVSS v3.1](https://www.first.org/cvss/specification-document) to assess the severity of the vulnerability.

7. When was the vulnerability introduced?

  - Find the responsible code path.
  - Find the commit or Pull Request that introduced the vulnerability.

8. Who are our security contacts?

  Assess upstream or downstream contacts, and their desired channels of security.

  > TODO: add a list of contacts.

### Mitigation

- **Primary focus:** removing possibility of exploitation fast.
- **Secondary focus:** addressing the root cause.

> [!IMPORTANT]
> Make sure to test that the mitigation works as expected, and does not introduce new vulnerabilities.
> When deploying a patch, make sure not to disclose the vulnerability in the commit message or PR description.

> TODO: introduce a fast-track update process for security patches.

### Disclosure

Primary goal: inform our users about the vulnerability, and whether they are affected or not affected based on information they should be able to check themselves in a straightforward way.

> TODO: add a vulnerability disclosure template.

### Learn

- Document the vulnerability, steps performed, and lessons learned.
- Document the timeline of events.
- Document and address improvements on the Security Incident Response Plan.
- Depending on the severity of the vulnerability, consider disclosing the root cause or not based on likely impact on users and estimated potential victims still affected.
