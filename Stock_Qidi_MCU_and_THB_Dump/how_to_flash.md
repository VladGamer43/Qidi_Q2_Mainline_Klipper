## Flashing via STM32CubeProgrammer (Windows)

### Prerequisites
- [STM32CubeProgrammer](https://www.st.com/en/development-tools/stm32cubeprog.html) installed
- ST-Link adapter connected to the board (see installation guide)

### Steps

1. **Open** STM32CubeProgrammer

2. **Select Interface**
   - Top right dropdown: select **ST-LINK**
   - Click the green **Connect** button
   - Status should show: `Connected`

3. **Navigate to the Erasing & Programming tab**
   - Click the icon that looks like a download arrow on the left sidebar

4. **Select the firmware file**
   - Click **Browse** and select your `.hex` file
   - The start address is automatically read from the `.hex` file — leave it as-is

5. **Flash the firmware**
   - Check **Verify programming** for safety
   - Click **Start Programming**
   - Wait for the success message: `File download complete`

6. **Disconnect**
   - Click **Disconnect** in the top right
   - Power cycle the board

> **Note:** If the connection fails, try enabling **"Connect under Reset"** in the ST-LINK settings before clicking Connect.