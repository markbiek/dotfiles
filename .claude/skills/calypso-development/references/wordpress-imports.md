# WordPress Package Imports

## @wordpress/components

UI components for WordPress interfaces:

**Layout**: `Card`, `CardBody`, `CardHeader`, `CardFooter`, `CardDivider`, `CardMedia`, `Flex`, `FlexBlock`, `FlexItem`, `HStack`, `VStack`, `Grid`, `Spacer`, `Surface`

**Forms**: `Button`, `ButtonGroup`, `CheckboxControl`, `ComboboxControl`, `FormFileUpload`, `FormTokenField`, `FormToggle`, `InputControl`, `NumberControl`, `RadioControl`, `RangeControl`, `SearchControl`, `SelectControl`, `TextControl`, `TextareaControl`, `ToggleControl`, `ToggleGroupControl`, `UnitControl`

**Feedback**: `Notice`, `NoticeList`, `Snackbar`, `SnackbarList`, `Spinner`, `Tooltip`

**Navigation**: `TabPanel`, `NavigableContainer`, `NavigableMenu`, `MenuItem`, `MenuGroup`

**Overlays**: `Modal`, `Popover`, `Dropdown`, `DropdownMenu`, `Guide`

**Pickers**: `ColorPicker`, `ColorPalette`, `DatePicker`, `DateTimePicker`, `TimePicker`, `FontSizePicker`, `GradientPicker`, `AnglePickerControl`, `FocalPointPicker`

**Display**: `Icon`, `Dashicon`, `Panel`, `PanelBody`, `PanelHeader`, `PanelRow`, `Placeholder`, `Truncate`, `VisuallyHidden`

**Other**: `Animate`, `BaseControl`, `Disabled`, `Draggable`, `DropZone`, `ResizableBox`, `ScrollLock`, `Shortcut`, `Slot`, `SlotFillProvider`

## @wordpress/block-editor

Block editor components:

**Core**: `BlockControls`, `BlockEdit`, `BlockIcon`, `BlockInspector`, `BlockList`, `BlockPreview`, `BlockToolbar`, `InnerBlocks`, `InspectorControls`, `InspectorAdvancedControls`

**Rich Content**: `RichText`, `PlainText`, `MediaPlaceholder`, `MediaUpload`, `MediaUploadCheck`

**Links**: `URLInput`, `URLInputButton`, `URLPopover`, `__experimentalLinkControl`

**Color/Typography**: `ColorPaletteControl`, `ContrastChecker`, `FontSizePicker`, `PanelColorSettings`, `withColors`, `withFontSizes`

**Utilities**: `useBlockProps`, `useInnerBlocksProps`, `store`, `transformStyles`, `getColorClassName`, `getFontSize`, `getFontSizeClass`

## @wordpress/data

State management (Redux-like):

**Core**: `select`, `dispatch`, `subscribe`, `resolveSelect`, `suspendSelect`

**Store Creation**: `createReduxStore`, `createRegistry`, `register`, `combineReducers`

**Selectors**: `createSelector`, `createRegistrySelector`, `createRegistryControl`

**React Hooks**: `useSelect`, `useDispatch`, `useRegistry`, `useSuspenseSelect`

**HOCs**: `withSelect`, `withDispatch`, `withRegistry`

**Context**: `RegistryProvider`, `RegistryConsumer`

**Utilities**: `batch`

## @wordpress/core-data

WordPress entity management:

**Records**: `getEntityRecord`, `getEntityRecords`, `getEditedEntityRecord`, `saveEntityRecord`, `deleteEntityRecord`, `editEntityRecord`, `hasEntityRecords`

**Config**: `getEntityConfig`, `getEntitiesConfig`

**Revisions**: `getRevisions`, `getRevision`, `getAutosave`, `getAutosaves`

**Permissions**: `canUser`, `canUserEditEntityRecord`, `getCurrentUser`

**Edit State**: `hasEditsForEntityRecord`, `hasUndo`, `hasRedo`, `undo`, `redo`

**React Hooks**: `useEntityRecord`, `useEntityRecords`, `useEntityProp`, `useEntityBlockEditor`, `useEntityId`, `useResourcePermissions`

**Status**: `isSavingEntityRecord`, `isDeletingEntityRecord`, `isAutosavingEntityRecord`, `getLastEntitySaveError`, `getLastEntityDeleteError`
