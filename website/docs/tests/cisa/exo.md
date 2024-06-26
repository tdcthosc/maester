---
sidebar_label: Exchange Online
description: Implementation of CISA Exchange Online Controls
---

# CISA Controls for Exchange Online

## Overview

The tests in this section verifies that a Microsoft 365 tenant’s **Exchange Online** configuration conforms to the policies described in the Secure Cloud Business Applications ([SCuBA](https://cisa.gov/scuba)) Security Configuration Baseline [documents](https://github.com/cisagov/ScubaGear/blob/main/baselines/README.md).

## Connecting to Azure, Exchange and other services

In order to run all the CISA tests, you need to install and connect to the Azure and Exchange Online modules.

See the [Installation guide](/docs/installation#optional-modules-and-permissions) for more information.

## Tests

| Cmdlet Name | CISA Control ID (Link) |
| - | - |
| Test-MtCisaAutoExternalForwarding | [MS.EXO.1.1v1](https://github.com/cisagov/ScubaGear/blob/main/PowerShell/ScubaGear/baselines/exo.md#msexo11v1) |
| Test-MtCisaSmtpAuthentication     | [MS.EXO.5.1v1](https://github.com/cisagov/ScubaGear/blob/main/PowerShell/ScubaGear/baselines/exo.md#msexo51v1) |
| Test-MtCisaContactSharing         | [MS.EXO.6.1v1](https://github.com/cisagov/ScubaGear/blob/main/PowerShell/ScubaGear/baselines/exo.md#msexo61v1) |
| Test-MtCisaCalendarSharing        | [MS.EXO.6.2v1](https://github.com/cisagov/ScubaGear/blob/main/PowerShell/ScubaGear/baselines/exo.md#msexo62v1) |
| Test-MtCisaExternalSenderWarning  | [MS.EXO.7.1v1](https://github.com/cisagov/ScubaGear/blob/main/PowerShell/ScubaGear/baselines/exo.md#msexo71v1) |
| Test-MtCisaAntiSpamAllowList      | [MS.EXO.12.1v1](https://github.com/cisagov/ScubaGear/blob/main/PowerShell/ScubaGear/baselines/exo.md#msexo121v1) |
| Test-MtCisaAntiSpamSafeList       | [MS.EXO.12.2v1](https://github.com/cisagov/ScubaGear/blob/main/PowerShell/ScubaGear/baselines/exo.md#msexo122v1) |
| Test-MtCisaMailboxAuditing        | [MS.EXO.13.1v1](https://github.com/cisagov/ScubaGear/blob/main/PowerShell/ScubaGear/baselines/exo.md#msexo131v1) |