package basic_demo;

import org.junit.Test;

import static org.junit.Assert.assertNotNull;

public class ChatServerAppTest {

    @Test
    public void testChatServerAppNotNull() {
        ChatServerApp chatServerApp = new ChatServerApp();
        assertNotNull(chatServerApp);
    }
}