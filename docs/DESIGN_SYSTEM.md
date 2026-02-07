# DoIt Design System

## Overview

The DoIt design system follows a minimalist black and white aesthetic, prioritizing high contrast, readability, and a modern dark mode-first approach. The design is inspired by chat-based interfaces like WhatsApp and ChatGPT, providing a familiar and intuitive user experience.

---

## Table of Contents

- [Color Palette](#color-palette)
- [Typography](#typography)
- [Components](#components)
- [Spacing & Layout](#spacing--layout)
- [Design Principles](#design-principles)
- [Iconography](#iconography)
- [Animations](#animations)

---

## Color Palette

The DoIt app uses a monochromatic color scheme with pure black and white, creating a clean, focused interface.

### Primary Colors

| Element | Color Name | Hex Code | RGB | Usage |
|---------|------------|----------|-----|-------|
| Primary Background | Pure Black | `#000000` | 0, 0, 0 | Main app background |
| Secondary Background | Dark Gray | `#1C1C1E` | 28, 28, 30 | Cards, modals, secondary areas |
| Card Background | Charcoal | `#2C2C2E` | 44, 44, 46 | Content cards, list items |

### Text Colors

| Element | Color Name | Hex Code | RGB | Usage |
|---------|------------|----------|-----|-------|
| Primary Text | Pure White | `#FFFFFF` | 255, 255, 255 | Headlines, body text, primary labels |
| Secondary Text | Light Gray | `#8E8E93` | 142, 142, 147 | Subtitles, captions, secondary labels |

### Accent Colors

| Element | Color Name | Hex Code | RGB | Usage |
|---------|------------|----------|-----|-------|
| Accent | Pure White | `#FFFFFF` | 255, 255, 255 | Buttons, active states, highlights |
| Success Indicator | White with Opacity | `rgba(255,255,255,0.8)` | 255, 255, 255, 0.8 | Success messages, completed states |

### Border & Divider Colors

| Element | Color Name | Hex Code | RGB | Usage |
|---------|------------|----------|-----|-------|
| Border/Divider | Dark Gray | `#3A3A3C` | 58, 58, 60 | Input borders, dividers, separators |

### Color Usage Guidelines

1. **Primary Background (`#000000`)**: Use for the main app background and full-screen views
2. **Secondary Background (`#1C1C1E`)**: Use for modals, sheets, and secondary content areas
3. **Card Background (`#2C2C2E`)**: Use for content cards, list items, and interactive elements
4. **Primary Text (`#FFFFFF`)**: Use for all primary text content
5. **Secondary Text (`#8E8E93`)**: Use for subtitles, captions, and less important information
6. **Accent (`#FFFFFF`)**: Use for buttons, active states, and interactive highlights
7. **Border (`#3A3A3C`)**: Use for input field borders and content dividers

### Color Implementation (Swift)

```swift
struct AppColors {
    static let primaryBackground = Color.black
    static let secondaryBackground = Color(red: 0.11, green: 0.11, blue: 0.12) // #1C1C1E
    static let cardBackground = Color(red: 0.17, green: 0.17, blue: 0.18) // #2C2C2E
    
    static let primaryText = Color.white
    static let secondaryText = Color(red: 0.56, green: 0.56, blue: 0.58) // #8E8E93
    
    static let accent = Color.white
    static let border = Color(red: 0.23, green: 0.23, blue: 0.24) // #3A3A3C
}
```

---

## Typography

The DoIt app uses Apple's SF Pro font family, providing a native iOS experience with excellent readability.

### Font Family

| Platform | Font Family |
|----------|-------------|
| iOS | SF Pro Display (headings), SF Pro Text (body) |

### Font Scale

| Element | Font | Weight | Size | Line Height | Usage |
|---------|------|--------|------|-------------|-------|
| Header | SF Pro Display | Bold | 32pt | 38pt | Page titles, main headings |
| Subheader | SF Pro Display | Semibold | 22pt | 28pt | Section titles, card headers |
| Body | SF Pro Text | Regular | 17pt | 22pt | Primary content, descriptions |
| Button | SF Pro Text | Semibold | 17pt | 22pt | Button labels, links |
| Caption | SF Pro Text | Regular | 13pt | 18pt | Secondary text, timestamps |

### Typography Guidelines

1. **Headers**: Use for page titles and main section headings
2. **Subheaders**: Use for card titles and section headers
3. **Body**: Use for all primary content and descriptions
4. **Button**: Use for button labels and interactive text
5. **Caption**: Use for timestamps, hints, and secondary information

### Typography Implementation (Swift)

```swift
struct AppFonts {
    static let header = Font.system(size: 32, weight: .bold, design: .default)
    static let subheader = Font.system(size: 22, weight: .semibold, design: .default)
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    static let button = Font.system(size: 17, weight: .semibold, design: .default)
    static let caption = Font.system(size: 13, weight: .regular, design: .default)
}
```

### Text Color Pairings

| Font Size | Primary Color | Secondary Color |
|-----------|---------------|-----------------|
| Header (32pt) | `#FFFFFF` | - |
| Subheader (22pt) | `#FFFFFF` | - |
| Body (17pt) | `#FFFFFF` | `#8E8E93` |
| Button (17pt) | `#000000` (on white) | - |
| Caption (13pt) | `#8E8E93` | - |

---

## Components

### Buttons

#### Primary Button

The primary button is used for main actions and CTAs.

**Specifications:**
- Height: 56pt
- Background: `#FFFFFF`
- Text Color: `#000000`
- Font: SF Pro Text Semibold, 17pt
- Corner Radius: 12pt
- Padding: Horizontal 20pt

**States:**
- **Default**: White background, black text
- **Pressed**: Slightly reduced opacity (0.8)
- **Disabled**: 50% opacity

**Implementation:**

```swift
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppColors.primaryBackground))
                        .padding(.trailing, 8)
                }
                
                Text(title)
                    .font(AppFonts.button)
                    .foregroundColor(AppColors.primaryBackground)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(AppColors.primaryText)
            .cornerRadius(12)
        }
        .disabled(isLoading)
    }
}
```

#### Secondary Button

The secondary button is used for secondary actions.

**Specifications:**
- Height: 56pt
- Background: `#2C2C2E`
- Text Color: `#FFFFFF`
- Font: SF Pro Text Semibold, 17pt
- Corner Radius: 12pt
- Border: 1pt `#3A3A3C`

---

### Input Fields

#### Onboarding Input Field

Used for text input during onboarding and forms.

**Specifications:**
- Height: 56pt
- Background: `#1C1C1E`
- Text Color: `#FFFFFF`
- Placeholder Color: `#8E8E93`
- Font: SF Pro Text Regular, 17pt
- Corner Radius: 12pt
- Border: 1pt `#3A3A3C`
- Padding: 16pt

**States:**
- **Default**: Dark gray background, gray border
- **Focused**: White border
- **Error**: Red border

**Implementation:**

```swift
struct OnboardingInputField: View {
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        TextField(placeholder, text: $text)
            .font(AppFonts.body)
            .foregroundColor(AppColors.primaryText)
            .padding()
            .frame(height: 56)
            .background(AppColors.secondaryBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.border, lineWidth: 1)
            )
            .keyboardType(keyboardType)
            .accentColor(AppColors.accent)
    }
}
```

---

### Cards

#### Goal Card

Used to display goal information in lists.

**Specifications:**
- Background: `#2C2C2E`
- Corner Radius: 12pt
- Padding: 16pt
- Border: None
- Shadow: None

**Content Structure:**
- Title: SF Pro Display Semibold, 17pt, `#FFFFFF`
- Description: SF Pro Text Regular, 15pt, `#8E8E93`
- Progress Bar: Height 4pt, Background `#3A3A3C`, Fill `#FFFFFF`
- Streak Badge: Circular, `#FFFFFF` background, `#000000` text

---

### Chat Bubbles

#### User Message Bubble

**Specifications:**
- Background: `#FFFFFF`
- Text Color: `#000000`
- Corner Radius: 18pt (top-right: 4pt)
- Padding: 12pt
- Max Width: 75% of screen

#### AI Message Bubble

**Specifications:**
- Background: `#2C2C2E`
- Text Color: `#FFFFFF`
- Corner Radius: 18pt (top-left: 4pt)
- Padding: 12pt
- Max Width: 75% of screen

---

### Verification Test Components

#### Quiz Question View

Displays a single question in the verification test.

**Specifications:**
- Background: `#2C2C2E`
- Corner Radius: 12pt
- Padding: 16pt
- Question Text: SF Pro Text Semibold, 17pt, `#FFFFFF`
- Options: Vertical stack, 8pt spacing

**Multiple Choice Option:**
- Background: `#1C1C1E`
- Border: 1pt `#3A3A3C`
- Corner Radius: 8pt
- Padding: 12pt
- Text: SF Pro Text Regular, 15pt, `#FFFFFF`
- Selected State: White border, `#FFFFFF` background, `#000000` text

**Code Completion Option:**
- Background: `#1C1C1E`
- Border: 1pt `#3A3A3C`
- Corner Radius: 8pt
- Padding: 12pt
- Code: SF Mono Regular, 14pt, `#FFFFFF`
- Input Field: Transparent background, white text

**Short Answer Option:**
- Background: `#1C1C1E`
- Border: 1pt `#3A3A3C`
- Corner Radius: 8pt
- Padding: 12pt
- Text: SF Pro Text Regular, 15pt, `#FFFFFF`

#### Quiz Progress View

Displays progress through the verification test.

**Specifications:**
- Height: 4pt
- Background: `#3A3A3C`
- Fill: `#FFFFFF`
- Corner Radius: 2pt
- Question Counter: SF Pro Text Regular, 13pt, `#8E8E93`
- Time Remaining: SF Pro Text Regular, 13pt, `#8E8E93`

#### Quiz Result View

Displays the result of the verification test.

**Specifications:**
- Background: `#2C2C2E`
- Corner Radius: 12pt
- Padding: 24pt

**Score Display:**
- Score Circle: 120pt diameter, `#FFFFFF` stroke, 2pt width
- Score Text: SF Pro Display Bold, 48pt, `#FFFFFF`
- Percentage: SF Pro Text Regular, 17pt, `#8E8E93`

**Status Message:**
- Passed: "Great job! You've mastered today's concepts." - SF Pro Text Semibold, 17pt, `#FFFFFF`
- Failed: "Keep practicing! Review the explanations below." - SF Pro Text Semibold, 17pt, `#FFFFFF`

**Question Feedback:**
- Background: `#1C1C1E`
- Corner Radius: 8pt
- Padding: 12pt
- Question: SF Pro Text Semibold, 15pt, `#FFFFFF`
- Your Answer: SF Pro Text Regular, 14pt, `#8E8E93`
- Correct Answer: SF Pro Text Regular, 14pt, `#FFFFFF`
- Explanation: SF Pro Text Regular, 14pt, `#8E8E93`

**Action Buttons:**
- Retry Button: Primary button style
- Continue Button: Primary button style

---

### Progress Indicators

#### Linear Progress Bar

**Specifications:**
- Height: 4pt
- Background: `#3A3A3C`
- Fill: `#FFFFFF`
- Corner Radius: 2pt

#### Circular Progress

**Specifications:**
- Size: 24pt
- Stroke Width: 2pt
- Track Color: `#3A3A3C`
- Progress Color: `#FFFFFF`

---

### Navigation

#### Tab Bar

**Specifications:**
- Height: 49pt (standard iOS)
- Background: `#1C1C1E`
- Border Top: 1pt `#3A3A3C`
- Icon Color: `#8E8E93` (inactive), `#FFFFFF` (active)
- Label Font: SF Pro Text Regular, 10pt

#### Navigation Bar

**Specifications:**
- Height: 44pt (standard iOS)
- Background: `#000000`
- Title Font: SF Pro Display Semibold, 17pt
- Title Color: `#FFFFFF`
- Back Button: SF Pro Text Regular, 17pt, `#FFFFFF`

---

## Spacing & Layout

### Spacing Scale

| Token | Value | Usage |
|-------|-------|-------|
| `spacing-xs` | 4pt | Tight spacing between related elements |
| `spacing-sm` | 8pt | Small spacing between elements |
| `spacing-md` | 16pt | Default spacing between elements |
| `spacing-lg` | 24pt | Large spacing between sections |
| `spacing-xl` | 32pt | Extra large spacing between major sections |
| `spacing-xxl` | 48pt | Maximum spacing for page-level layout |

### Layout Guidelines

#### Safe Area Padding

- **Top**: Use safe area top + 16pt
- **Bottom**: Use safe area bottom + 20pt
- **Leading**: 16pt
- **Trailing**: 16pt

#### Content Width

- **Maximum Content Width**: 600pt (on larger screens)
- **Minimum Touch Target**: 44pt × 44pt

#### Grid System

The app uses a flexible grid system based on screen width:

| Screen Width | Columns | Gutter |
|--------------|---------|--------|
| < 375pt | 1 column | 16pt |
| 375pt - 414pt | 1 column | 16pt |
| > 414pt | 2 columns | 16pt |

---

## Design Principles

### 1. Minimalist

The design prioritizes simplicity and clarity. Remove unnecessary elements and focus on essential content.

**Guidelines:**
- Use ample white space
- Limit color palette to black and white
- Avoid decorative elements
- Focus on content hierarchy

### 2. High Contrast

Ensure all text and interactive elements are easily readable in all lighting conditions.

**Guidelines:**
- Maintain minimum contrast ratio of 4.5:1 for body text
- Use pure white on pure black for maximum contrast
- Avoid gray-on-gray combinations
- Test in both light and dark environments

### 3. Dark Mode First

Design primarily for dark mode, with battery efficiency and modern aesthetics in mind.

**Guidelines:**
- Use pure black backgrounds for OLED efficiency
- Ensure all elements work well on dark backgrounds
- Avoid light backgrounds unless necessary
- Test on OLED displays

### 4. Chat-Centric

Follow familiar chat interface patterns for intuitive navigation and interaction.

**Guidelines:**
- Use message bubbles for AI responses
- Implement familiar chat gestures (swipe, long press)
- Maintain conversation flow
- Use timestamps and read receipts where appropriate

### 5. Accessibility First

Ensure the app is usable by everyone, including users with disabilities.

**Guidelines:**
- Support Dynamic Type for text scaling
- Provide VoiceOver labels for all elements
- Maintain minimum touch targets of 44pt
- Support Reduce Motion preference
- Use semantic HTML/SwiftUI elements

---

## Iconography

### Icon Style

- **Style**: SF Symbols (iOS native)
- **Weight**: Medium
- **Size**: 24pt (default), 18pt (small), 32pt (large)
- **Color**: `#FFFFFF` (primary), `#8E8E93` (secondary)

### Common Icons

| Icon | SF Symbol | Usage |
|------|-----------|-------|
| Home | `house.fill` | Home tab |
| Goals | `target` | Goals tab |
| Groups | `person.2.fill` | Groups tab |
| Profile | `person.fill` | Profile tab |
| Settings | `gearshape.fill` | Settings |
| Add | `plus.circle.fill` | Create new item |
| Delete | `trash.fill` | Delete item |
| Edit | `pencil` | Edit item |
| Check | `checkmark.circle.fill` | Completed state |
| Chevron | `chevron.right` | Navigation indicator |
| Back | `chevron.left` | Back navigation |
| Send | `paperplane.fill` | Send message |
| Streak | `flame.fill` | Streak indicator |
| Quiz | `questionmark.circle.fill` | Verification test |
| Timer | `timer` | Test timer |
| Trophy | `trophy.fill` | Perfect score achievement |
| Retry | `arrow.clockwise.circle.fill` | Retry test |
| Correct | `checkmark.circle` | Correct answer |
| Incorrect | `xmark.circle` | Incorrect answer |

### Icon Usage Guidelines

1. Use SF Symbols for consistency with iOS
2. Maintain consistent sizing within contexts
3. Use filled icons for active states
4. Use outlined icons for inactive states
5. Ensure minimum touch target of 44pt × 44pt

---

## Animations

### Animation Principles

- **Duration**: 0.2s - 0.3s for most transitions
- **Easing**: Ease-in-out for natural feel
- **Performance**: Use hardware-accelerated animations
- **Respect**: Honor Reduce Motion accessibility setting

### Standard Animations

| Animation | Duration | Easing | Usage |
|-----------|----------|--------|-------|
| Fade In | 0.2s | Ease-in | View appearance |
| Fade Out | 0.2s | Ease-out | View dismissal |
| Slide Up | 0.3s | Ease-in-out | Sheet presentation |
| Slide Down | 0.3s | Ease-in-out | Sheet dismissal |
| Scale | 0.2s | Ease-in-out | Button press |
| Bounce | 0.4s | Spring | Success feedback |

### Animation Implementation (Swift)

```swift
// Fade transition
withAnimation(.easeIn(duration: 0.2)) {
    isVisible = true
}

// Slide transition
withAnimation(.easeInOut(duration: 0.3)) {
    offset = 0
}

// Spring animation
withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
    scale = 1.0
}
```

---

## Responsive Design

### Breakpoints

| Device | Width | Layout |
|--------|-------|--------|
| iPhone SE | 375pt | Single column |
| iPhone 14/15 | 390pt | Single column |
| iPhone 14/15 Pro Max | 430pt | Single column |
| iPad Mini | 744pt | Single column (centered) |
| iPad Pro | 1024pt | Two columns |

### Adaptive Layout

- Use `GeometryReader` for responsive layouts
- Implement adaptive spacing based on screen width
- Use `@Environment(\.horizontalSizeClass)` for layout decisions
- Support landscape orientation where appropriate

---

## Component States

### Button States

| State | Background | Text | Opacity |
|-------|------------|------|---------|
| Default | `#FFFFFF` | `#000000` | 100% |
| Pressed | `#FFFFFF` | `#000000` | 80% |
| Disabled | `#FFFFFF` | `#000000` | 50% |
| Loading | `#FFFFFF` | `#000000` | 100% |

### Input Field States

| State | Background | Border | Text |
|-------|------------|--------|------|
| Default | `#1C1C1E` | `#3A3A3C` | `#FFFFFF` |
| Focused | `#1C1C1E` | `#FFFFFF` | `#FFFFFF` |
| Error | `#1C1C1E` | `#FF0000` | `#FFFFFF` |
| Disabled | `#1C1C1E` | `#3A3A3C` | `#8E8E93` |

---

## Design Tokens

### Color Tokens

```swift
enum AppColorToken {
    case primaryBackground
    case secondaryBackground
    case cardBackground
    case primaryText
    case secondaryText
    case accent
    case border
}
```

### Spacing Tokens

```swift
enum AppSpacingToken {
    case xs    // 4pt
    case sm    // 8pt
    case md    // 16pt
    case lg    // 24pt
    case xl    // 32pt
    case xxl   // 48pt
}
```

### Typography Tokens

```swift
enum AppFontToken {
    case header
    case subheader
    case body
    case button
    case caption
}
```

---

## Design Resources

### Figma (Recommended)

- Create a Figma file with all components
- Use component variants for different states
- Document all design tokens
- Share with development team

### Asset Export

- Export icons as SVG or PDF
- Export images at @2x and @3x scales
- Use named colors in asset catalog
- Organize assets by feature

---

## Design Review Checklist

Before implementing a new screen or component:

- [ ] Follows color palette guidelines
- [ ] Uses correct typography scale
- [ ] Maintains proper spacing
- [ ] Supports Dynamic Type
- [ ] Works in dark mode
- [ ] Has proper accessibility labels
- [ ] Respects Reduce Motion setting
- [ ] Has appropriate touch targets
- [ ] Follows component specifications
- [ ] Tested on multiple device sizes
