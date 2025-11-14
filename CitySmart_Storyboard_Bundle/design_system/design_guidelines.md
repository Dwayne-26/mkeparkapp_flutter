# CitySmart Design System - Milwaukee Edition

## Color Palette

### Primary Colors
```
Milwaukee Navy: #003366
- Primary buttons, headers, navigation
- Hex: #003366
- RGB: rgb(0, 51, 102)
- Usage: Main brand color, high contrast elements

Cream White: #F5F5DC
- Background, cards, secondary elements
- Hex: #F5F5DC
- RGB: rgb(245, 245, 220)
- Usage: Light backgrounds, contrast with navy

Lake Blue: #4A90A4
- Accent color, links, interactive elements
- Hex: #4A90A4
- RGB: rgb(74, 144, 164)
- Usage: Secondary actions, highlights
```

### Semantic Colors
```
Success Green: #28A745
- Available parking, successful actions
- Hex: #28A745
- RGB: rgb(40, 167, 69)

Warning Orange: #FFC107
- Limited availability, caution alerts
- Hex: #FFC107
- RGB: rgb(255, 193, 7)

Danger Red: #DC3545
- Occupied spots, errors, violations
- Hex: #DC3545
- RGB: rgb(220, 53, 69)

Info Blue: #17A2B8
- Reserved spots, information
- Hex: #17A2B8
- RGB: rgb(23, 162, 184)
```

### Neutral Grays
```
Dark Gray: #343A40
- Primary text, headers
- Hex: #343A40

Medium Gray: #6C757D
- Secondary text, descriptions
- Hex: #6C757D

Light Gray: #E9ECEF
- Borders, dividers
- Hex: #E9ECEF

Background Gray: #F8F9FA
- Page backgrounds, disabled elements
- Hex: #F8F9FA
```

## Typography

### Font Family
- **Primary**: SF Pro Display (iOS), Roboto (Android)
- **Fallback**: System UI fonts
- **Code/Numbers**: SF Mono, Roboto Mono

### Type Scale
```
Display Large: 57px / 64px line height
- Hero sections, splash screens
- Weight: 400 (Regular)

Display Medium: 45px / 52px line height
- Main page headers
- Weight: 400 (Regular)

Headline Large: 32px / 40px line height
- Section headers, modal titles
- Weight: 400 (Regular)

Headline Medium: 28px / 36px line height
- Card titles, important labels
- Weight: 400 (Regular)

Title Large: 22px / 28px line height
- List item titles, button labels
- Weight: 500 (Medium)

Body Large: 16px / 24px line height
- Primary body text, descriptions
- Weight: 400 (Regular)

Body Medium: 14px / 20px line height
- Secondary text, captions
- Weight: 400 (Regular)

Label Large: 14px / 20px line height
- Button text, form labels
- Weight: 500 (Medium)

Label Medium: 12px / 16px line height
- Small labels, metadata
- Weight: 500 (Medium)
```

## Spacing System

### Base Unit: 8px

```
XXS: 4px   (0.5x)
XS:  8px   (1x)
S:   12px  (1.5x)
M:   16px  (2x)
L:   24px  (3x)
XL:  32px  (4x)
XXL: 48px  (6x)
```

### Usage Guidelines
- **Component padding**: 16px (M)
- **Section margins**: 24px (L)
- **Page margins**: 16px (M) mobile, 24px (L) tablet+
- **Element spacing**: 8px (XS) - 16px (M)

## Component Library

### Buttons

#### Primary Button
```
Background: Milwaukee Navy (#003366)
Text: White (#FFFFFF)
Padding: 12px 24px
Border Radius: 8px
Font: Label Large, Medium weight
Min Height: 48px (touch target)
```

#### Secondary Button
```
Background: Transparent
Border: 2px solid Lake Blue (#4A90A4)
Text: Lake Blue (#4A90A4)
Padding: 10px 22px (adjusted for border)
Border Radius: 8px
Font: Label Large, Medium weight
Min Height: 48px
```

#### Text Button
```
Background: Transparent
Text: Lake Blue (#4A90A4)
Padding: 12px 16px
Font: Label Large, Medium weight
No border, underline on hover
```

### Cards

#### Standard Card
```
Background: Cream White (#F5F5DC)
Border Radius: 12px
Padding: 16px
Shadow: 0px 2px 8px rgba(0, 0, 0, 0.1)
Border: 1px solid Light Gray (#E9ECEF)
```

#### Elevated Card
```
Background: White (#FFFFFF)
Border Radius: 12px
Padding: 20px
Shadow: 0px 4px 16px rgba(0, 0, 0, 0.15)
No border
```

### Form Elements

#### Text Input
```
Background: White (#FFFFFF)
Border: 2px solid Light Gray (#E9ECEF)
Border Radius: 8px
Padding: 12px 16px
Font: Body Large
Height: 48px
Focus: Border color changes to Lake Blue
```

#### Select Dropdown
```
Background: White (#FFFFFF)
Border: 2px solid Light Gray (#E9ECEF)
Border Radius: 8px
Padding: 12px 16px
Font: Body Large
Height: 48px
Chevron icon on right
```

### Icons

#### Style Guidelines
- **Style**: Outlined (2px stroke weight)
- **Size**: 24px standard, 20px small, 32px large
- **Color**: Inherits text color or uses semantic colors
- **Grid**: 24x24px grid system

#### Common Icons
- Parking: P in circle
- Navigation: Arrow pointing right
- Location: Pin/marker
- Time: Clock
- Payment: Credit card
- Alert: Triangle with exclamation
- Success: Checkmark in circle
- Menu: Three horizontal lines

## Layout Grid

### Mobile (< 768px)
- **Columns**: 4
- **Margins**: 16px
- **Gutters**: 16px
- **Max width**: 100%

### Tablet (768px - 1024px)
- **Columns**: 8
- **Margins**: 24px
- **Gutters**: 24px
- **Max width**: 100%

### Desktop (> 1024px)
- **Columns**: 12
- **Margins**: 24px
- **Gutters**: 24px
- **Max width**: 1200px

## Accessibility Guidelines

### Color Contrast
- Text on background: Minimum 4.5:1 ratio
- Large text: Minimum 3:1 ratio
- UI elements: Minimum 3:1 ratio

### Touch Targets
- Minimum size: 44x44px
- Recommended: 48x48px
- Spacing: Minimum 8px between targets

### Focus States
- Visible focus indicators on all interactive elements
- 2px solid outline in Milwaukee Navy
- Sufficient contrast against all backgrounds

---
*Design system for CitySmart v1.6 - Milwaukee Implementation*