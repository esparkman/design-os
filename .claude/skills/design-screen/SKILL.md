---
name: design-screen
description: Create ViewComponent screen designs that match existing patterns. Use to build new screens with props-based components following the established design system.
---

# /design-screen

Create ViewComponent-based screen designs that match the established design system. All components are props-based and portable.

## Usage

```
/design-screen invoices/list
/design-screen dashboard
/design-screen settings/profile
```

## Purpose

- Create ViewComponents for screens matching established patterns
- Generate props-based, portable components
- Include Stimulus controllers when interactivity is needed
- Ensure responsive design and dark mode support
- Create Lookbook previews for visual testing

## Prerequisites

Before designing screens, ensure:
1. `/analyze-app` has been run (brownfield) or `/product-vision` completed (greenfield)
2. `/design-tokens` has established the color/typography system
3. The section has been shaped with `/shape-section` (optional but recommended)

---

## Step 1: Gather Context

### Load Design Context

```bash
# Check for brownfield context
cat design-context/manifest.json 2>/dev/null

# Load design tokens
cat design-context/tokens/colors.json 2>/dev/null
cat design-context/tokens/typography.json 2>/dev/null

# Load existing patterns
ls design-context/patterns/ 2>/dev/null
```

### Query Pensieve

Use `pensieve_recall` to get relevant context:

```json
{
  "query": "patterns components"
}
```

### Check Section Specification

If a section spec exists:

```bash
cat product/sections/[section]/specification.md 2>/dev/null
```

---

## Step 2: Understand Screen Requirements

Ask the user or infer from section spec:

```
## Screen Design: [section/screen]

I'll design this screen for you. Please confirm:

1. **Screen Purpose:** What is this screen for?
2. **Key Actions:** What can users do here?
3. **Data Displayed:** What information is shown?
4. **Navigation:** Where does this screen fit in the app?

Or, if you have a section spec, I'll use that.
```

---

## Step 3: Design Component Structure

Break down the screen into ViewComponents:

```
## Component Structure

### Screen: InvoiceListScreen
├── PageHeaderComponent
│   ├── title: "Invoices"
│   ├── description: "Manage your invoices"
│   └── actions: [CreateInvoiceButton]
├── InvoiceFiltersComponent
│   ├── status_filter
│   ├── date_range
│   └── search
├── InvoiceListComponent
│   └── InvoiceRowComponent (repeated)
│       ├── invoice_number
│       ├── client_name
│       ├── amount
│       ├── status_badge
│       └── actions: [view, edit, delete]
└── PaginationComponent
```

---

## Step 4: Create ViewComponents

### Component Structure Rules

1. **Props-based:** All data via `initialize` parameters
2. **No database queries:** Components receive data, don't fetch it
3. **Slots for flexibility:** Use `renders_one` and `renders_many`
4. **Variants via props:** No conditional class logic in templates

### Example: Main Screen Component

```ruby
# app/components/invoices/invoice_list_screen_component.rb
# frozen_string_literal: true

class Invoices::InvoiceListScreenComponent < ViewComponent::Base
  renders_one :header, PageHeaderComponent
  renders_many :filters
  renders_one :pagination, PaginationComponent

  def initialize(invoices:, current_filter: nil, pagination: nil)
    @invoices = invoices
    @current_filter = current_filter
    @pagination = pagination
  end

  private

  attr_reader :invoices, :current_filter, :pagination
end
```

```erb
<%# app/components/invoices/invoice_list_screen_component.html.erb %>
<div class="min-h-screen bg-stone-50 dark:bg-stone-900">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <%= header %>

    <% if filters.any? %>
      <div class="mt-6 flex flex-wrap gap-4">
        <% filters.each do |filter| %>
          <%= filter %>
        <% end %>
      </div>
    <% end %>

    <div class="mt-6">
      <%= render Invoices::InvoiceListComponent.new(invoices: invoices) %>
    </div>

    <% if pagination %>
      <div class="mt-6">
        <%= pagination %>
      </div>
    <% end %>
  </div>
</div>
```

### Example: List Component

```ruby
# app/components/invoices/invoice_list_component.rb
# frozen_string_literal: true

class Invoices::InvoiceListComponent < ViewComponent::Base
  def initialize(invoices:, on_view: nil, on_edit: nil)
    @invoices = invoices
    @on_view = on_view
    @on_edit = on_edit
  end

  private

  attr_reader :invoices, :on_view, :on_edit
end
```

```erb
<%# app/components/invoices/invoice_list_component.html.erb %>
<div class="bg-white dark:bg-stone-800 shadow-sm rounded-lg overflow-hidden">
  <table class="min-w-full divide-y divide-stone-200 dark:divide-stone-700">
    <thead class="bg-stone-50 dark:bg-stone-700">
      <tr>
        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-stone-500 dark:text-stone-300 uppercase tracking-wider">
          Invoice
        </th>
        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-stone-500 dark:text-stone-300 uppercase tracking-wider">
          Client
        </th>
        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-stone-500 dark:text-stone-300 uppercase tracking-wider">
          Amount
        </th>
        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-stone-500 dark:text-stone-300 uppercase tracking-wider">
          Status
        </th>
        <th scope="col" class="relative px-6 py-3">
          <span class="sr-only">Actions</span>
        </th>
      </tr>
    </thead>
    <tbody class="bg-white dark:bg-stone-800 divide-y divide-stone-200 dark:divide-stone-700">
      <% invoices.each do |invoice| %>
        <%= render Invoices::InvoiceRowComponent.new(invoice: invoice) %>
      <% end %>
    </tbody>
  </table>
</div>
```

### Example: Row Component

```ruby
# app/components/invoices/invoice_row_component.rb
# frozen_string_literal: true

class Invoices::InvoiceRowComponent < ViewComponent::Base
  def initialize(invoice:)
    @invoice = invoice
  end

  private

  attr_reader :invoice

  def status_classes
    case invoice.status
    when "paid"
      "bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200"
    when "pending"
      "bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200"
    when "overdue"
      "bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200"
    else
      "bg-stone-100 text-stone-800 dark:bg-stone-700 dark:text-stone-200"
    end
  end
end
```

```erb
<%# app/components/invoices/invoice_row_component.html.erb %>
<tr class="hover:bg-stone-50 dark:hover:bg-stone-700/50 transition-colors">
  <td class="px-6 py-4 whitespace-nowrap">
    <div class="text-sm font-medium text-stone-900 dark:text-stone-100">
      <%= invoice.number %>
    </div>
    <div class="text-sm text-stone-500 dark:text-stone-400">
      <%= invoice.date.strftime("%b %d, %Y") %>
    </div>
  </td>
  <td class="px-6 py-4 whitespace-nowrap">
    <div class="text-sm text-stone-900 dark:text-stone-100"><%= invoice.client_name %></div>
    <div class="text-sm text-stone-500 dark:text-stone-400"><%= invoice.client_email %></div>
  </td>
  <td class="px-6 py-4 whitespace-nowrap text-sm text-stone-900 dark:text-stone-100">
    <%= number_to_currency(invoice.amount) %>
  </td>
  <td class="px-6 py-4 whitespace-nowrap">
    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full <%= status_classes %>">
      <%= invoice.status.capitalize %>
    </span>
  </td>
  <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
    <%= link_to "View", invoice_path(invoice),
        class: "text-indigo-600 hover:text-indigo-900 dark:text-indigo-400 dark:hover:text-indigo-300" %>
  </td>
</tr>
```

---

## Step 5: Add Stimulus Controllers (If Needed)

When interactivity is required, create Stimulus controllers:

```javascript
// app/javascript/controllers/invoice_list_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["row", "search", "statusFilter"]
  static values = {
    filterUrl: String
  }

  filter() {
    const query = this.searchTarget.value
    const status = this.statusFilterTarget.value

    // Filter rows or submit to server
    this.rowTargets.forEach(row => {
      const matchesQuery = row.dataset.searchable.toLowerCase().includes(query.toLowerCase())
      const matchesStatus = !status || row.dataset.status === status
      row.classList.toggle("hidden", !(matchesQuery && matchesStatus))
    })
  }

  search() {
    clearTimeout(this.searchTimeout)
    this.searchTimeout = setTimeout(() => this.filter(), 300)
  }
}
```

Reference in template:

```erb
<div data-controller="invoice-list">
  <input type="search"
         data-invoice-list-target="search"
         data-action="input->invoice-list#search"
         placeholder="Search invoices..."
         class="...">
  <!-- ... -->
</div>
```

---

## Step 6: Create Lookbook Previews

Generate Lookbook preview for visual testing:

```ruby
# test/components/previews/invoices/invoice_list_screen_component_preview.rb
class Invoices::InvoiceListScreenComponentPreview < ViewComponent::Preview
  # @label Default
  def default
    invoices = SampleData::Invoices.list(count: 10)
    render Invoices::InvoiceListScreenComponent.new(invoices: invoices)
  end

  # @label Empty State
  def empty
    render Invoices::InvoiceListScreenComponent.new(invoices: [])
  end

  # @label With Filters Active
  def with_filters
    invoices = SampleData::Invoices.list(count: 5, status: "pending")
    render Invoices::InvoiceListScreenComponent.new(
      invoices: invoices,
      current_filter: { status: "pending" }
    )
  end

  # @label With Pagination
  def with_pagination
    invoices = SampleData::Invoices.list(count: 10)
    pagination = OpenStruct.new(
      current_page: 2,
      total_pages: 5,
      per_page: 10,
      total_count: 47
    )
    render Invoices::InvoiceListScreenComponent.new(
      invoices: invoices,
      pagination: pagination
    )
  end
end
```

---

## Step 7: Document the Screen

Create screen documentation:

```markdown
# product/sections/invoices/screens/list.md

## Invoice List Screen

### Purpose
Display all invoices with filtering, search, and pagination.

### Components Used
- `PageHeaderComponent` - Screen title and actions
- `InvoiceListComponent` - Table of invoices
- `InvoiceRowComponent` - Individual invoice row
- `PaginationComponent` - Page navigation

### Props
| Component | Prop | Type | Required |
|-----------|------|------|----------|
| InvoiceListScreenComponent | invoices | Array<Invoice> | Yes |
| InvoiceListScreenComponent | current_filter | Hash | No |
| InvoiceListScreenComponent | pagination | PaginationData | No |

### Stimulus Controllers
- `invoice-list` - Client-side filtering and search

### Responsive Behavior
- **Mobile:** Cards instead of table rows
- **Tablet:** Condensed table
- **Desktop:** Full table with all columns

### Dark Mode
Fully supported with `dark:` variants on all elements.

### Sample Data
See `lib/sample_data/invoices.rb`
```

---

## Step 8: Save to Pensieve

Record the screen design:

```json
{
  "type": "discovery",
  "category": "component",
  "name": "InvoiceListScreenComponent",
  "location": "app/components/invoices/invoice_list_screen_component.rb",
  "description": "Main screen for invoice list with filters, table, and pagination"
}
```

Record any design decisions:

```json
{
  "type": "decision",
  "topic": "Invoice List - Layout",
  "content": "Using table layout for desktop, card layout for mobile via responsive classes",
  "rationale": "Tables work well for data-dense views on desktop but are unusable on mobile"
}
```

---

## Output Summary

```
## Screen Designed: invoices/list

### Components Created
- `Invoices::InvoiceListScreenComponent` - Main screen wrapper
- `Invoices::InvoiceListComponent` - Invoice table
- `Invoices::InvoiceRowComponent` - Table row with status badge

### Stimulus Controllers
- `invoice_list_controller.js` - Search and filter functionality

### Files Created
- `app/components/invoices/invoice_list_screen_component.rb`
- `app/components/invoices/invoice_list_screen_component.html.erb`
- `app/components/invoices/invoice_list_component.rb`
- `app/components/invoices/invoice_list_component.html.erb`
- `app/components/invoices/invoice_row_component.rb`
- `app/components/invoices/invoice_row_component.html.erb`
- `app/javascript/controllers/invoice_list_controller.js`
- `test/components/previews/invoices/invoice_list_screen_component_preview.rb`

### Preview in Lookbook
Visit `/lookbook/preview/invoices/invoice_list_screen_component`

### Next Steps
1. Run `/sample-data invoices` to generate test data
2. Review in Lookbook at the preview URL
3. Connect to real data in controller
```

---

## Design Guidelines

### Responsive Design

Always include responsive variants:

```erb
<%# Mobile first, then scale up %>
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
```

### Dark Mode

Every color class needs a `dark:` variant:

```erb
<div class="bg-white dark:bg-stone-800 text-stone-900 dark:text-stone-100">
```

### Accessibility

- Use semantic HTML (`<nav>`, `<main>`, `<button>`)
- Include `aria-*` attributes where needed
- Ensure color contrast meets WCAG AA
- Add `sr-only` labels for icon-only buttons

### Match Existing Patterns

In brownfield mode, reference `design-context/patterns/` to ensure new screens match existing conventions.

---

## Notes

- All components are props-based for portability
- Use Lookbook for visual testing before integration
- Save all discoveries to Pensieve for continuity
- Prefer composition over inheritance
- Keep components focused and single-purpose
