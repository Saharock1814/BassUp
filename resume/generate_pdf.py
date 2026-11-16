#!/usr/bin/env python3
"""Generate Mikhail Denisov resume PDF."""

from pathlib import Path

from fpdf import FPDF

OUT = Path(__file__).with_name("Mikhail_Denisov_Resume.pdf")
FONT = "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf"
FONT_BOLD = "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf"
FONT_ITALIC = "/usr/share/fonts/truetype/liberation/LiberationSans-Italic.ttf"


class ResumePDF(FPDF):
    def footer(self) -> None:
        self.set_y(-12)
        self.set_font("Sans", "", 8)
        self.set_text_color(120, 120, 120)
        self.cell(0, 8, f"Mikhail Denisov  ·  Page {self.page_no()}/{{nb}}", align="C")


def section_title(pdf: ResumePDF, title: str) -> None:
    pdf.ln(3)
    pdf.set_font("Sans", "B", 12)
    pdf.set_text_color(20, 20, 20)
    pdf.cell(0, 7, title, new_x="LMARGIN", new_y="NEXT")
    pdf.set_draw_color(40, 40, 40)
    pdf.set_line_width(0.4)
    y = pdf.get_y()
    pdf.line(pdf.l_margin, y, pdf.w - pdf.r_margin, y)
    pdf.ln(3)


def bullet(pdf: ResumePDF, text: str) -> None:
    pdf.set_font("Sans", "", 10)
    pdf.set_text_color(30, 30, 30)
    pdf.set_x(pdf.l_margin)
    pdf.multi_cell(0, 5, f"•  {text}")


def job_header(pdf: ResumePDF, role: str, company: str, meta: str) -> None:
    pdf.set_font("Sans", "B", 11)
    pdf.set_text_color(20, 20, 20)
    pdf.cell(0, 6, f"{role} — {company}", new_x="LMARGIN", new_y="NEXT")
    pdf.set_font("Sans", "I", 9)
    pdf.set_text_color(70, 70, 70)
    pdf.cell(0, 5, meta, new_x="LMARGIN", new_y="NEXT")
    pdf.ln(1)


def sub_role(pdf: ResumePDF, role: str, dates: str) -> None:
    pdf.set_font("Sans", "B", 10)
    pdf.set_text_color(20, 20, 20)
    pdf.cell(0, 5, f"{role} · {dates}", new_x="LMARGIN", new_y="NEXT")
    pdf.ln(0.5)


def stack_line(pdf: ResumePDF, text: str) -> None:
    pdf.set_x(pdf.l_margin)
    pdf.set_font("Sans", "I", 9)
    pdf.set_text_color(60, 60, 60)
    pdf.multi_cell(0, 4.5, text)
    pdf.ln(1)


def main() -> None:
    pdf = ResumePDF(format="A4")
    pdf.alias_nb_pages()
    pdf.set_auto_page_break(auto=True, margin=16)
    pdf.set_margins(16, 14, 16)
    pdf.add_page()
    pdf.add_font("Sans", "", FONT)
    pdf.add_font("Sans", "B", FONT_BOLD)
    pdf.add_font("Sans", "I", FONT_ITALIC)

    # Header
    pdf.set_font("Sans", "B", 20)
    pdf.set_text_color(15, 15, 15)
    pdf.cell(0, 9, "Mikhail Denisov", new_x="LMARGIN", new_y="NEXT")
    pdf.set_font("Sans", "B", 11)
    pdf.set_text_color(40, 40, 40)
    pdf.cell(
        0,
        6,
        "Lead QA Engineer | QA Automation (Python, TypeScript, Playwright)",
        new_x="LMARGIN",
        new_y="NEXT",
    )
    pdf.set_font("Sans", "", 9)
    pdf.set_text_color(70, 70, 70)
    pdf.multi_cell(
        0,
        4.5,
        "Serbia · Open to remote and relocation · +381 62 937 9276 · "
        "verden.rinkihika@gmail.com · Telegram: @Secerock_m · LinkedIn",
    )

    section_title(pdf, "Summary")
    pdf.set_font("Sans", "", 10)
    pdf.set_text_color(30, 30, 30)
    pdf.multi_cell(
        0,
        5,
        "Lead QA Engineer with 8+ years of experience in web, mobile and API testing "
        "across EdTech, FinTech, ride-hailing and smart city products. Built QA processes "
        "and teams from scratch, led a QA team of up to 5 engineers, and delivered 650+ "
        "automated tests integrated into CI/CD. Strong in Python and TypeScript automation "
        "(Playwright, PyTest, Requests) and in using AI tools (Claude, Cursor, Playwright MCP) "
        "to speed up test design and automation.",
    )

    section_title(pdf, "Skills")
    skills = [
        (
            "Test automation: ",
            "Python, TypeScript, Playwright, PyTest, Selenium, Appium, "
            "Robot Framework, Requests",
        ),
        ("AI tools: ", "Claude, Cursor, Playwright MCP"),
        ("API & debugging: ", "Postman, Swagger, Charles, cURL, Chrome DevTools"),
        ("CI/CD & infrastructure: ", "GitHub Actions, GitLab CI, Docker, Linux, Bash, AWS S3"),
        ("Performance & monitoring: ", "Locust, Grafana"),
        ("Databases: ", "SQL, PostgreSQL, Oracle"),
        ("Test management: ", "Allure, Qase.io, Jira"),
        (
            "Leadership: ",
            "QA strategy and planning, building QA from scratch, hiring, mentoring",
        ),
    ]
    for label, value in skills:
        pdf.set_font("Sans", "B", 10)
        pdf.set_text_color(30, 30, 30)
        pdf.write(5, label)
        pdf.set_font("Sans", "", 10)
        pdf.write(5, value)
        pdf.ln(5.5)

    section_title(pdf, "Experience")

    job_header(pdf, "Lead QA Engineer", "RD Solutions", "Smart city systems · Mar 2026 – Present")
    for b in [
        "Built the QA function from scratch: processes, test strategy, test plans, reporting standards, test cases and checklists for all projects",
        "Hiring and mentoring the QA team",
        "Leading testing of a smart city hardware/software system with deep LLM integration and a multi-service web platform, plus internal promo projects",
        "Active work with live streaming and WebRTC: signaling, ICE / TURN–STUN connectivity, media quality and latency under unstable networks, reconnect and failover scenarios",
        "Expanding automation for streaming and WebRTC critical paths (connection setup, media negotiation, session recovery)",
        "Grew the automation suite to 150+ tests in under a year and expanding it actively",
    ]:
        bullet(pdf, b)
    stack_line(pdf, "Stack: Playwright, TypeScript, Python, Requests, Docker, Bash, SSH, Linux, WebRTC, streaming media")

    job_header(
        pdf,
        "Senior QA Engineer",
        "Reluna",
        "Wealth management platform · Nov 2024 – Feb 2026",
    )
    for b in [
        "Sole QA on two products, owning the full QA cycle from requirements to release",
        "Designed and led UI automation (Python, Playwright) and API automation (Python, Requests)",
        "Tested and maintained CI/CD pipelines in GitLab CI",
        "Built QA processes for both teams",
        "Used Claude AI in development and testing of an AI-based product to speed up test design and automation",
    ]:
        bullet(pdf, b)
    pdf.ln(1)

    pdf.set_font("Sans", "B", 11)
    pdf.set_text_color(20, 20, 20)
    pdf.cell(0, 6, "UCHI.RU — #1 EdTech company in Russia", new_x="LMARGIN", new_y="NEXT")
    pdf.set_font("Sans", "I", 9)
    pdf.set_text_color(70, 70, 70)
    pdf.cell(
        0,
        5,
        "Jan 2021 – Sep 2024 · promoted from QA Engineer to Lead QA Engineer",
        new_x="LMARGIN",
        new_y="NEXT",
    )
    pdf.ln(1)

    sub_role(pdf, "Lead QA Engineer", "Aug 2023 – Sep 2024")
    for b in [
        "Led a newly formed QA team of up to 5 engineers within a new product, covering the full STLC from test planning to regression",
        "Defined and adopted all STLC stages for the product",
        "Built a CI/CD process for automated test suites (GitHub Actions)",
        "Delivered 650+ automated UI and API tests (Selenium, PyTest, Requests)",
        "Supported product growth from 25 to 70 engineers and a 10x revenue increase",
    ]:
        bullet(pdf, b)
    stack_line(
        pdf,
        "Stack: Selenium, PyTest, Requests, Appium, PostgreSQL, Charles, Jira, Qase.io, GitHub Actions, AWS S3",
    )

    sub_role(pdf, "QA Engineer", "Jan 2021 – Aug 2023")
    for b in [
        "Full-cycle testing of the payments system: requirements review, test design, feature and regression testing",
        "Supported numerous payment A/B experiments",
        "Started the automation suite (Selenium, PyTest)",
        "Reached 2 consecutive months with zero critical defects found",
    ]:
        bullet(pdf, b)
    stack_line(
        pdf,
        "Stack: Selenium, PyTest, Postman, PostgreSQL, Charles, Jira, Qase.io, GitHub Actions, AWS S3",
    )

    job_header(
        pdf,
        "QA Engineer",
        "Aram Meem",
        "Ride-hailing and delivery platform, Saudi Arabia · Jul 2020 – Jan 2021",
    )
    for b in [
        "Designed and executed test plans for back-office services",
        "Automated key regression cases in Python and validated data integrity with SQL",
        "Cut the testing cycle by 25% by streamlining the test process",
    ]:
        bullet(pdf, b)
    pdf.ln(1)

    job_header(
        pdf,
        "Test Designer",
        "Performance Lab",
        "Banking commission calculation module · Oct 2019 – Jul 2020",
    )
    bullet(
        pdf,
        "Functional, integration, end-to-end and regression testing; prepared infrastructure for test automation",
    )
    stack_line(pdf, "Stack: Oracle, Kafka Tool, Jira, HP ALM")

    job_header(
        pdf,
        "Junior QA Engineer",
        "Kaluga-Astral",
        "Electronic document management desktop app · May 2018 – Oct 2019",
    )
    bullet(pdf, "Manual and regression testing (VMware, TeamCity, Redmine)")

    section_title(pdf, "Languages")
    pdf.set_font("Sans", "", 10)
    pdf.set_text_color(30, 30, 30)
    pdf.cell(
        0,
        5,
        "Russian — native · English — B2 (upper-intermediate) · Serbian — A1",
        new_x="LMARGIN",
        new_y="NEXT",
    )

    pdf.output(OUT)
    print(f"Wrote {OUT}")


if __name__ == "__main__":
    main()
